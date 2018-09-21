variable "compartment_ocid" {}
variable "instance_shape" {}

variable "instance_image_ocid" {
  type = "map"
}

variable "bm_subnet_ocid" {}
variable "hyperv_subnet_ocid" {}
variable "AD" {}
variable "region" {}
variable "tenancy_ocid" {}

data "oci_identity_availability_domains" "ADs" {
  compartment_id = "${var.tenancy_ocid}"
}

resource "oci_core_instance" "bm_instance" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "TF BM Instance"
  shape               = "${var.instance_shape}"
  subnet_id           = "${var.bm_subnet_ocid}"

  create_vnic_details {
    subnet_id        = "${var.bm_subnet_ocid}"
    hostname_label   = "bminstancevnic"
    display_name     = "BM Instance VNIC"
    assign_public_ip = true
  }

  source_details {
    source_type = "image"
    source_id   = "${var.instance_image_ocid[var.region]}"
  }

  timeouts {
    create = "60m"
  }
}

resource "oci_core_vnic_attachment" "bm_vnic_2" {
  instance_id = "${oci_core_instance.bm_instance.id}"
  nic_index   = "1"

  create_vnic_details {
    subnet_id        = "${var.hyperv_subnet_ocid}"
    assign_public_ip = true
    display_name     = "BM Instance VNIC 2"
  }
}

resource "oci_core_vnic_attachment" "hvnat_vnic" {
  instance_id = "${oci_core_instance.bm_instance.id}"
  nic_index   = "1"

  create_vnic_details {
    subnet_id              = "${var.hyperv_subnet_ocid}"
    assign_public_ip       = true
    display_name           = "hvnat vnic"
    skip_source_dest_check = true
  }

  depends_on = ["oci_core_vnic_attachment.bm_vnic_2"]
}

resource "oci_core_vnic_attachment" "hvrouter_vnic" {
  instance_id = "${oci_core_instance.bm_instance.id}"
  nic_index   = "1"

  create_vnic_details {
    subnet_id              = "${var.hyperv_subnet_ocid}"
    assign_public_ip       = true
    display_name           = "hvrouter vnic"
    skip_source_dest_check = true
  }

  depends_on = ["oci_core_vnic_attachment.bm_vnic_2"]
}
