output "name" {
  value = docker_container.this.name
}

output "ip_address" {
  value = docker_container.this.network_data[0].ip_address
}
