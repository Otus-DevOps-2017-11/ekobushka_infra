variable project {
  description = "Project ID"
}

variable region {
  description = "Region from which to list available zones"
  default     = "europe-west1"
}

variable region_zone {
  description = "The zone that the machine should be created in"
  default     = "europe-west1-b"
}

variable network_name {
  description = "The name or self_link of the network to attach this interface to"
  default     = "default"
}

variable machine_type {
  description = "The machine type to create"
  default     = "g1-small"
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

variable ssh_allow_source_ranges {
  description = "allowed access range for access"
  default     = ["0.0.0.0/0"]
}

variable tags_app_name {
  description = "Tag: application name"
}

variable app_port {
  description = "Used application port"
  default     = "9292"
}

variable db_address {
  description = "Used database IP-address"
  default     = "127.0.0.1"
}

variable db_port {
  description = "Used database port"
  default     = "27017"
}

variable ssh_port {
  description = "Used port for ssh service"
  default     = "22"
}

variable tags_db_name {
  description = "Tag: mongoDB name"
}

variable num_devices {
  description = "Number of instances created"
  default     = "2"
}

variable app_disk_image {
  description = "The image from which to initialize this disk (reddit app)"
  default     = "reddit-base-app"
}

variable db_disk_image {
  description = "The image from which to initialize this disk (mongoDB)"
  default     = "reddit-base-db"
}
