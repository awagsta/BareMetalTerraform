output "hyperv_subnet_ocid" {
  value = "${oci_core_subnet.hyperv_subnet.id}"
}

output "bm_subnet_ocid" {
  value = "${oci_core_subnet.bare_metal_subnet.id}"
}
