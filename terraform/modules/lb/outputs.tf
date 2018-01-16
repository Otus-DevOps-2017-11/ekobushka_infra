output "lb_external_ip" {
  value = "${google_compute_global_forwarding_rule.defaul-forward-http-rule.ip_address}"
}
