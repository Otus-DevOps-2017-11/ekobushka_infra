variable region_zone {
  description = "The zone that the machine should be created in"
}

variable network_name {
  description = "The name or self_link of the network to attach this interface to"
}

variable machine_type {
  description = "The machine type to create"
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

variable tags_app_name {
  description = "Tag: application name"
}

variable app_name {
  description = "Application Name"
}

variable app_port {
  description = "Used application port"
}

variable db_address {
  description = "Used database IP-address"
  default     = "127.0.0.1"
}

variable db_port {
  description = "Used database port"
  default     = "27017"
}

variable num_devices {
  description = "Number of instances created"
}

variable app_disk_image {
  description = "The image from which to initialize this disk"
  default     = "reddit-base-app"
}
