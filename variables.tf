variable "docker_host" {
  type    = string
  default = "unix:///var/run/docker.sock"
}

variable "project" {
  type    = string
  default = "lab"
}

variable "web_port" {
  type    = number
  default = 8080
}

variable "subnet" {
  type    = string
  default = "172.28.0.0/16"
}
