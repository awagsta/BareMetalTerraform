variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "region" {}
variable "compartment_ocid" {}

variable "vcn_cidr" {
  default = "10.0.0.0/16"
}

variable "bm_subnet_cidrs" {
  type = "list"
  default = ["10.0.0.0/24, 10.0.2.0/24, 10.0.4.0/24"]
}

variable "hyperv_subnet_cidrs" {
  type = "list"
  default = ["10.0.1.0/24, 10.0.3.0/24, 10.0.5.0/24"]
}


data "oci_identity_availability_domains" "ADs" {
  compartment_id = "${var.tenancy_ocid}"
}

resource "oci_core_virtual_network" "bare_metal_vcn" {
  cidr_block     = "${var.vcn_cidr}"
  compartment_id = "${var.compartment_ocid}"
  display_name   = "Bare metal VCN"
  dns_label      = "bmvcn"
}

resource "oci_core_subnet" "bare_metal_subnet" {
  count = "3"
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[count.index],"name")}"
  cidr_block          = "${element(var.bm_subnet_cidrs, count.index%3)}"
  display_name        = "Bare Metal Subnet ${count.index+1}"
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.bare_metal_vcn.id}"
  route_table_id      = "${oci_core_route_table.bare_metal_route_table.id}"
  security_list_ids   = ["${oci_core_virtual_network.bare_metal_vcn.default_security_list_id}", "${oci_core_security_list.bare_metal_security_list.id}"]
  dhcp_options_id     = "${oci_core_virtual_network.bare_metal_vcn.default_dhcp_options_id}"
  dns_label           = "bmsubnet ${count.index+1}"
}

resource "oci_core_subnet" "hyperv_subnet" {
  count  = "3"
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[count.index],"name")}"
  cidr_block          = "${element(var.hyperv_subnet_cidrs, count.index%3)}"
  display_name        = "Hyper-V Subnet ${count.index+1}"
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.bare_metal_vcn.id}"
  route_table_id      = "${oci_core_route_table.bare_metal_route_table.id}"
  security_list_ids   = ["${oci_core_virtual_network.bare_metal_vcn.default_security_list_id}", "${oci_core_security_list.bare_metal_security_list.id}"]
  dhcp_options_id     = "${oci_core_virtual_network.bare_metal_vcn.default_dhcp_options_id}"
  dns_label           = "hypervsubnet ${count.index+1}"
}

resource "oci_core_internet_gateway" "bare_metal_gateway" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "Bare Metal Gateway"
  vcn_id         = "${oci_core_virtual_network.bare_metal_vcn.id}"
}

resource "oci_core_security_list" "bare_metal_security_list" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.bare_metal_vcn.id}"
  display_name   = "Bare Metal Security List"

  ingress_security_rules {
    source   = "192.168.0.0/16"
    protocol = "all"
  }
}

resource "oci_core_default_route_table" "default-route-table" {
  manage_default_resource_id = "${oci_core_virtual_network.bare_metal_vcn.default_route_table_id}"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = "${oci_core_internet_gateway.bare_metal_gateway.id}"
  }
}

resource "oci_core_route_table" "bare_metal_route_table" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.bare_metal_vcn.id}"
  display_name   = "Bare Metal Route Table"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = "${oci_core_internet_gateway.bare_metal_gateway.id}"
  }
}
