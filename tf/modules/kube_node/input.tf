variable "ssh_id" {
  type = string
}

variable "init_hostname" {
  type = string
}

variable "name" {
  type = string
}

variable "environment" {
  type = string
}

variable "server" {
  type        = map(string)
  description = "Server configuration"
  default     = {}
}

variable "install_microk8s" {
  type    = bool
  default = false
}
