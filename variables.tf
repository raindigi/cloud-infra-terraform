variable "localhost_ip" {
  type        = string
  description = "IP address of your local machine (this IP address will get SSH access to the instances)."
}

variable "public_key_file" {
  type        = string
  description = "Path to a public key file in OpenSSH format on your local machine (e.g. '~/.ssh/id_rsa.pub')."
}
