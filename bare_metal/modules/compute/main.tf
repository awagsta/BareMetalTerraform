variable "compartment_ocid" {}
variable "instance_shape" {}

variable "instance_image_ocid" {
  type = "map"
}

variable "bm_subnet_ocids" {
  type = "list"
}

variable "region" {}
variable "tenancy_ocid" {}

data "oci_identity_availability_domains" "ADs" {
  compartment_id = "${var.tenancy_ocid}"
}

resource "oci_core_instance" "bm_instance" {
  count = "3"
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[count.index % 3],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "TF BM Instance ${count.index+1}"
  shape               = "${var.instance_shape}"
  subnet_id           = "${element(var.bm_subnet_ocids, count.index%3)}"

  create_vnic_details {
    subnet_id        = "${element(var.bm_subnet_ocids, count.index%3)}"
    display_name     = "BM Instance ${count.index+1} VNIC"
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