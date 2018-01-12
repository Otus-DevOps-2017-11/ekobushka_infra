# В этой секции правим метаданные нашего проета (общие для всего проекта)
resource "google_compute_project_metadata" "infra" {
  metadata {
    ssh-keys = "${var.public_sshuser}:${file(var.public_sshkey_path)}appuser:${file(var.public_sshkey_path)}"
  }
}

# Правило файрвола для SSH
resource "google_compute_firewall" "firewall_allow_ssh" {
  name    = "default-allow-ssh"
  network = "${var.network_name}"

  allow {
    protocol = "tcp"
    ports    = ["${var.ssh_port}"]
  }

  source_ranges = "${var.source_ranges}"
}
