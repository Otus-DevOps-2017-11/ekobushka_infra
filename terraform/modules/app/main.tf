data "template_file" "puma_service" {
  template = "${file("${path.module}/template/puma.service.tpl")}"

  vars {
    db_address = "${var.db_address}"
    db_port    = "${var.db_port}"
    app_user   = "${var.public_sshuser}"
  }
}

# Создание инстансов с помощью count
resource "google_compute_instance" "app" {
  # чтобы изменить количество создаваемых инстансов изменить переменную в
  # variables.tf
  count = "${var.num_devices}"

  name         = "${var.tags_app_name}-${count.index}"
  machine_type = "${var.machine_type}"
  zone         = "${var.region_zone}"

  tags = ["${var.tags_app_name}"]

  boot_disk {
    initialize_params {
      image = "${var.app_disk_image}"
    }
  }

  network_interface {
    network       = "${var.network_name}"
    access_config = {}
  }

  connection {
    type        = "ssh"
    user        = "${var.public_sshuser}"
    agent       = false
    private_key = "${file(var.private_sshkey_path)}"
  }

  provisioner "file" {
    content     = "${data.template_file.puma_service.rendered}"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "${path.module}/scripts/deploy.sh"
  }
}

# Правило файрвола для нашего приложения
resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["${var.app_port}"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.tags_app_name}"]
}
