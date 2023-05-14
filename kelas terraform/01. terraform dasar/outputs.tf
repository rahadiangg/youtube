output "public_ip_vm_test-2" {
  value       = google_compute_instance.test-2.network_interface[0].access_config[0].nat_ip
  description = "IP public dari VM test-2"
}