variable public_sshuser {
  description = "Username for public ssh"
}

variable public_sshkey_path {
  description = "Path to the public key used for ssh access"
}

variable private_sshkey_path {
  description = "Path to the public key used for ssh access"
}

variable network_name {
  description = "The name or self_link of the network to attach this interface to"
}

variable source_ranges {
  description = "Allowed IP addresses"
  default     = ["0.0.0.0/0"]
}

variable ssh_port {
  description = "Used port for ssh service"
  default     = "22"
}
