output "instance_1_ip" {
  value       = "Instance created with IP: ${oci_core_instance.bm_instance_1.public_ip}"
  description = "The public ip of the bare metal instance"
}

output "instance_2_ip" {
  value       = "Instance created with IP: ${oci_core_instance.bm_instance_2.public_ip}"
  description = "The public ip of the bare metal instance"
}

output "instance_3_ip" {
  value       = "Instance created with IP: ${oci_core_instance.bm_instance_3.public_ip}"
  description = "The public ip of the bare metal instance"
}
