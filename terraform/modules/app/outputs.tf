output "app_external_ip" {
  value = "${google_compute_instance.app.*.network_interface.0.access_config.0.assigned_nat_ip}"
}

output "lb_app_array_list" {
  value = "${google_compute_instance.app.*.self_link}"
}
