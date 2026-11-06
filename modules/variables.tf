variable "name" {
  type = string
}

variable "alias" {
  type = string
}

variable "image" {
  type = string
}

variable "network_name" {
  type = string
}

variable "ports" {
  type = list(object({
    internal = number
    external = number
  }))
  default = []
}

variable "env" {
  type    = list(string)
  default = []
}

variable "volume_name" {
  type    = string
  default = null
}

variable "container_path" {
  type    = string
  default = null
}

variable "healthcheck" {
  type    = list(string)
  default = null
}
