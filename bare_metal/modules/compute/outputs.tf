output "instance_ips" {
  value       = ["${oci_core_instance.bm_instance.*.public_ip}"]
  description = "The public ips of the bare metal instances"
}

output "instance_ocids" {
  value = ["${oci_core_instance.bm_instance.*.id}"]
}
