output "hyperv_subnet_1_ocid" {
  value = "${oci_core_subnet.hyperv_subnet_1.id}"
}

output "bm_subnet_1_ocid" {
  value = "${oci_core_subnet.bare_metal_subnet_1.id}"
}

output "hyperv_subnet_2_ocid" {
  value = "${oci_core_subnet.hyperv_subnet_2.id}"
}

output "bm_subnet_2_ocid" {
  value = "${oci_core_subnet.bare_metal_subnet_2.id}"
}

output "hyperv_subnet_3_ocid" {
  value = "${oci_core_subnet.bare_metal_subnet_3.id}"
}

output "bm_subnet_3_ocid" {
  value = "${oci_core_subnet.bare_metal_subnet_3.id}"
}
