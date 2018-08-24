output "instance_ip" {
  value       = "Instance created with IP: ${oci_core_instance.bm_instance.public_ip}"
  description = "The public ip of the bare metal instance"
}

output "hvnat_information" {
  value = "The IP of the hvnat vnic: ${oci_core_vnic_attachment.hvnat_vnic.public_ip}"
}

output "hvrouter_information" {
  value = "The IP of the hvnat vnic: ${oci_core_vnic_attachment.hvrouter_vnic.public_ip}"
}

output "bm_nic_information" {
  value = "The IP of the bare metal vnic 2: ${oci_core_vnic_attachment.bm_vnic_2.public_ip}"
}
