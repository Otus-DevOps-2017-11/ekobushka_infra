provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

module "vpc" {
  source              = "../modules/vpc"
  ssh_port            = "${var.ssh_port}"
  public_sshuser      = "${var.public_sshuser}"
  public_sshkey_path  = "${var.public_sshkey_path}"
  private_sshkey_path = "${var.private_sshkey_path}"
  network_name        = "${var.network_name}"
  source_ranges       = "${var.ssh_allow_source_ranges}"
}

module "db" {
  source              = "../modules/db"
  machine_type        = "${var.machine_type}"
  tags_db_name        = "${var.tags_db_name}"
  tags_app_name       = "${var.tags_app_name}"
  db_port             = "${var.db_port}"
  public_sshuser      = "${var.public_sshuser}"
  public_sshkey_path  = "${var.public_sshkey_path}"
  private_sshkey_path = "${var.private_sshkey_path}"
  region_zone         = "${var.region_zone}"
  network_name        = "${var.network_name}"
  db_disk_image       = "${var.db_disk_image}"
}

module "app" {
  source              = "../modules/app"
  num_devices         = "${var.num_devices}"
  machine_type        = "${var.machine_type}"
  tags_app_name       = "${var.tags_app_name}"
  public_sshuser      = "${var.public_sshuser}"
  public_sshkey_path  = "${var.public_sshkey_path}"
  private_sshkey_path = "${var.private_sshkey_path}"
  region_zone         = "${var.region_zone}"
  network_name        = "${var.network_name}"
  app_name            = "${var.tags_app_name}"
  app_port            = "${var.app_port}"
  db_address          = "${module.db.db_internal_ip}"
  db_port             = "${var.db_port}"
  app_disk_image      = "${var.app_disk_image}"
}

# module "lb" {
#   source         = "../modules/lb"
#   region_zone    = "${var.region_zone}"
#   app_port       = "${var.app_port}"
#   list_instanses = "${module.app.lb_app_array_list}"
# }
