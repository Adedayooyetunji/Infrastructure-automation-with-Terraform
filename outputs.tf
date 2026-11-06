output "web_url" {
  value = "http://localhost:${var.web_port}"
}

output "network_id" {
  value = docker_network.app.id
}

output "service_ips" {
  value = { for k, m in module.service : k => m.ip_address }
}
