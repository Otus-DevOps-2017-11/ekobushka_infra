variable region_zone {
  description = "The zone that the machine should be created in"
}

variable machine_type {
  description = "The machine type to create"
}

variable network_name {
  description = "The name or self_link of the network to attach this interface to"
}

variable public_sshuser {
  description = "Username for public ssh"
}

variable public_sshkey_path {
  description = "Path to the public key used for ssh access"
}

variable private_sshkey_path {
  description = "Path to the public key used for ssh access"
}

variable tags_db_name {
  description = "Tag: mongoDB name"
}

variable tags_app_name {
  description = "Tag: application name"
}

variable db_port {
  description = "Used database port"
}

variable db_disk_image {
  description = "The image from which to initialize this disk"
}
