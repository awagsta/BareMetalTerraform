output "instance_ip" {
  value       = "Instance created with IP: ${oci_core_instance.bm_instance.public_ip}"
  description = "The public ip of the bare metal instance"
}
