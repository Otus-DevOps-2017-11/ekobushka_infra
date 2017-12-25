provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

# В этой секции правим метаданные нашего проета (общие для всего проекта)
resource "google_compute_project_metadata" "infra" {
  metadata {
    ssh-keys = "${var.public_sshuser}:${file(var.public_sshkey_path)}appuser:${file(var.public_sshkey_path)}"
  }
}

# Правило файрвола для нашего приложения
resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.tags_app_name}"]
}

# Описание создания первого инстанса
resource "google_compute_instance" "app1" {
  name         = "${var.tags_app_name}-1"
  machine_type = "${var.machine_type}"
  zone         = "${var.region_zone}"

  tags = ["${var.tags_app_name}"]

  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  network_interface {
    network       = "${var.network_name}"
    access_config = {}
  }

  # Если необходимо использовать персональные ключи SSH для доступа к инстансу
  # то используем закомментированные ниже строки
  # metadata {
  #  sshKeys = "${var.public_sshuser}:${file(var.public_sshkey_path)}"
  #}

  connection {
    type        = "ssh"
    user        = "${var.public_sshuser}"
    agent       = false
    private_key = "${file(var.private_sshkey_path)}"
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}

# Описание создания второго инстанса
resource "google_compute_instance" "app2" {
  name         = "${var.tags_app_name}-2"
  machine_type = "${var.machine_type}"
  zone         = "${var.region_zone}"

  tags = ["${var.tags_app_name}"]

  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  network_interface {
    network       = "${var.network_name}"
    access_config = {}
  }

  # Если необходимо использовать персональные ключи SSH для доступа к инстансу
  # то используем закомментированные ниже строки
  #metadata {
  #  sshKeys = "${var.public_sshuser}:${file(var.public_sshkey_path)}"
  #}

  connection {
    type        = "ssh"
    user        = "${var.public_sshuser}"
    agent       = false
    private_key = "${file(var.private_sshkey_path)}"
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}

# Описываем группу инстансов для балансировщика
resource "google_compute_instance_group" "all-puma-group" {
  name        = "all-puma-group"
  description = "Terraform testing instance group"

  instances = [
    "${google_compute_instance.app1.self_link}",
    "${google_compute_instance.app2.self_link}",
  ]

  named_port {
    name = "http"
    port = "9292"
  }

  zone = "${var.region_zone}"
}

# правила проверки работоспособности инстансов
resource "google_compute_http_health_check" "puma-http-health-check" {
  name               = "puma-http-health-check"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
  port               = "9292"
}

# описываем группу хостов для балансировщика
resource "google_compute_backend_service" "puma-backend" {
  name          = "puma-backend"
  port_name     = "http"
  protocol      = "HTTP"
  timeout_sec   = 10
  health_checks = ["${google_compute_http_health_check.puma-http-health-check.self_link}"]

  backend {
    group = "${google_compute_instance_group.all-puma-group.self_link}"
  }
}

# описываем правила отправки запросов от балансировщика
resource "google_compute_url_map" "url-map-puma-group" {
  name            = "url-map-puma-group"
  description     = "url maps"
  default_service = "${google_compute_backend_service.puma-backend.self_link}"

  host_rule {
    hosts        = ["*"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = "${google_compute_backend_service.puma-backend.self_link}"

    path_rule {
      paths   = ["/*"]
      service = "${google_compute_backend_service.puma-backend.self_link}"
    }
  }
}

# добавляем в файрвол правила для балансировщика
resource "google_compute_global_forwarding_rule" "defaul-forward-http-rule" {
  name       = "defaul-forward-http-rule"
  target     = "${google_compute_target_http_proxy.reddit-http-proxy.self_link}"
  port_range = "80"
}

resource "google_compute_target_http_proxy" "reddit-http-proxy" {
  name        = "reddit-http-proxy"
  description = "Application reddit proxy"
  url_map     = "${google_compute_url_map.url-map-puma-group.self_link}"
}
