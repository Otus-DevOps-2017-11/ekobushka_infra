variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}

variable region_zone {
  description = "Region"
  default     = "europe-west1-b"
}

variable network_name {
  description = "Name network"
  default     = "default"
}

variable machine_type {
  description = "Type"
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

variable disk_image {
  description = "Disk image"
}

variable tags_app_name {
  description = "Application name for tag"
}
