locals {
  services = {
    web = {
      image       = "nginx:1.27-alpine"
      ports       = [{ internal = 80, external = var.web_port }]
      env         = []
      healthcheck = ["CMD", "wget", "-q", "--spider", "http://localhost/"]
    }
    redis = {
      image          = "redis:7-alpine"
      ports          = []
      env            = []
      volume_name    = "${var.project}-redis-data"
      container_path = "/data"
      healthcheck    = ["CMD", "redis-cli", "ping"]
    }
  }
}

resource "docker_network" "app" {
  name   = "${var.project}-net"
  driver = "bridge"

  ipam_config {
    subnet = var.subnet
  }
}

module "service" {
  source   = "./modules/service"
  for_each = local.services

  name           = "${var.project}-${each.key}"
  alias          = each.key
  image          = each.value.image
  network_name   = docker_network.app.name
  ports          = each.value.ports
  env            = each.value.env
  volume_name    = try(each.value.volume_name, null)
  container_path = try(each.value.container_path, null)
  healthcheck    = try(each.value.healthcheck, null)
}
