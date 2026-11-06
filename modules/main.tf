terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

resource "docker_image" "this" {
  name         = var.image
  keep_locally = true
}

resource "docker_volume" "this" {
  count = var.volume_name == null ? 0 : 1
  name  = var.volume_name
}

resource "docker_container" "this" {
  name    = var.name
  image   = docker_image.this.image_id
  restart = "unless-stopped"
  env     = var.env

  networks_advanced {
    name    = var.network_name
    aliases = [var.alias]
  }

  dynamic "ports" {
    for_each = var.ports
    content {
      internal = ports.value.internal
      external = ports.value.external
    }
  }

  dynamic "volumes" {
    for_each = docker_volume.this
    content {
      volume_name    = volumes.value.name
      container_path = var.container_path
    }
  }

  dynamic "healthcheck" {
    for_each = var.healthcheck == null ? [] : [var.healthcheck]
    content {
      test     = healthcheck.value
      interval = "10s"
      timeout  = "3s"
      retries  = 3
    }
  }
}
