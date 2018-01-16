# Описываем группу инстансов для балансировщика
resource "google_compute_instance_group" "all-puma-group" {
  name        = "all-puma-group"
  description = "Terraform testing instance group"

  instances = [
    "${var.list_instanses}",
  ]

  named_port {
    name = "http"
    port = "${var.app_port}"
  }

  zone = "${var.region_zone}"
}

# правила проверки работоспособности инстансов
resource "google_compute_http_health_check" "puma-http-health-check" {
  name               = "puma-http-health-check"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
  port               = "${var.app_port}"
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
