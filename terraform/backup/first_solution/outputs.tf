output "app1_external_ip" {
  value = "${google_compute_instance.app1.network_interface.0.access_config.0.assigned_nat_ip}"
}

output "app2_external_ip" {
  value = "${google_compute_instance.app2.network_interface.0.access_config.0.assigned_nat_ip}"
}

output "lb_external_ip" {
  value = "${google_compute_global_forwarding_rule.defaul-forward-http-rule.ip_address}"
}
