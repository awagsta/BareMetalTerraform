provider "oci" {
  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid    = "${var.user_ocid}"
  fingerprint  = "${var.fingerprint}"
  region       = "${var.region}"
}

data "oci_identity_availability_domains" "ADs" {
  compartment_id = "${var.tenancy_ocid}"
}

resource "oci_core_virtual_network" "bare_metal_vcn" {
  cidr_block     = "10.0.0.0/16"
  compartment_id = "${var.compartment_ocid}"
  display_name   = "Baremetal VCN"
  dns_label      = "bare_oci_core_virtual_network.bare_metal_vcn"
}

resource "oci_core_subnet" "bare_metal_subnet" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}"
  cidr_block          = "10.0.0.0/24"
  display_name        = "Baremetal Subnet"
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.bare_metal_vcn.id}"
  route_table_id      = "${oci_core_virtual_network.bare_metal_vcn.default_route_table_id}"
  security_list_ids   = ["${oci_core_virtual_network.bare_metal_vcn.default_security_list_id}"]
  dhcp_options_id     = "${oci_core_virtual_network.bare_metal_vcn.default_dhcp_options_id}"
  dns_label           = "baremetalsubnet"
}

resource "oci_core_subnet" "hyperv_subnet" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}"
  cidr_block          = "10.0.1.0/24"
  display_name        = "Hyper-V Subnet"
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.bare_metal_vcn.id}"
  route_table_id      = "${oci_core_virtual_network.bare_metal_vcn.default_route_table_id}"
  security_list_ids   = ["${oci_core_virtual_network.bare_metal_vcn.default_security_list_id}"]
  dhcp_options_id     = "${oci_core_virtual_network.bare_metal_vcn.default_dhcp_options_id}"
  dns_label           = "hypervsubnet"
}

resource "oci_core_internet_gateway" "bare_metal_gateway" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "Baremetal Gateway"
  vcn_id         = "${oci_core_virtual_network.bare_metal_vcn.id}"
}

resource "oci_core_instance" "bm_instance" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "BM Instance"
  image               = "${var.instance_image_ocid[var.region]}"
  shape               = "${var.instance_shape}"
  subnet_id           = "${oci_core_subnet.bare_metal_subnet.id}"

  create_vnic_details {
    subnet_id        = "${oci_core_subnet.bare_metal_subnet.id}"
    hostname_label   = "bminstancevnic"
    display_name     = "BM Instance VNIC"
    assign_public_ip = true
  }

  timeouts {
    create = "60m"
  }
}

resource "oci_core_vnic_attachment" "bm_vnic_2" {
  instance_id = "${oci_core_instance.bm_instance.id}"
  nic_index   = "1"

  create_vnic_details {
    subnet_id        = "${oci_core_subnet.hyperv_subnet.id}"
    assign_public_ip = true
    display_name     = "BM Instance VNIC 2"
  }
}

resource "oci_core_vnic_attachment" "hvnat_vnic" {
  instance_id = "${oci_core_instance.bm_instance.id}"
  nic_index   = "1"

  create_vnic_details {
    subnet_id              = "${oci_core_subnet.hyperv_subnet.id}"
    assign_public_ip       = true
    display_name           = "hvnat vnic"
    skip_source_dest_check = true
  }
}

resource "oci_core_vnic_attachment" "hvrouter_vnic" {
  instance_id = "${oci_core_instance.bm_instance.id}"
  nic_index   = "1"

  create_vnic_details {
    subnet_id              = "${oci_core_subnet.hyperv_subnet.id}"
    assign_public_ip       = true
    display_name           = "hvrouter vnic"
    skip_source_dest_check = true
  }
}

resource "oci_core_security_list" "bare_metal_security_list" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.bare_metal_vcn.id}"
  display_name   = "Bare Metal Security List"

  ingress_security_rules {
    destination = "192.168.0.0/16"
    protocol    = "all"
  }
}
