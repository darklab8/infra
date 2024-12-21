variable "name" {
  type    = string
  default = ""
}

variable "description" {
  type    = string
  default = ""
}

variable "public" {
  type = bool
}

variable "group_gitlab_id" {
  type = string
}

variable "homepage_url" {
  type    = string
  default = null
}

variable "secrets" {
  type   = map(string)
  default = {}
}