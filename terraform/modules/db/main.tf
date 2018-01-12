resource "google_compute_instance" "db" {
  name         = "${var.tags_db_name}"
  machine_type = "${var.machine_type}"
  zone         = "${var.region_zone}"
  tags         = ["${var.tags_db_name}"]

  boot_disk {
    initialize_params {
      image = "${var.db_disk_image}"
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

  # metadata {
  #     sshKeys = "appuser:${file(var.public_key_path)}"
  # }

  provisioner "remote-exec" {
    inline = [
      "sudo sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf",
      "sudo sed -i 's/27017/${var.db_port}/' /etc/mongod.conf",
      "sudo systemctl restart mongod",
    ]
  }
}

resource "google_compute_firewall" "firewall_mongo" {
  name    = "allow-mongo-default"
  network = "${var.network_name}"

  allow {
    protocol = "tcp"
    ports    = ["${var.db_port}"]
  }

  # правило применимо к инстансам с тегом ...
  target_tags = ["${var.tags_db_name}"]

  # порт будет доступен только для инстансов с тегом ...
  source_tags = ["${var.tags_app_name}"]
}
