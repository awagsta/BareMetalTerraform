variable "instance_ocids" {
  type = "list"
}

variable "hyperv_subnet_ocids" {
  type = "list"
}

resource "oci_core_vnic_attachment" "bm_vnic_2" {
  count       = "3"
  instance_id = "${element(var.instance_ocids, count.index%3)}"
  nic_index   = "1"

  create_vnic_details {
    subnet_id        = "${element(var.hyperv_subnet_ocids, count.index%3)}"
    assign_public_ip = true
    display_name     = "BM Instance ${count.index + 1} VNIC 2"
  }
}

resource "oci_core_vnic_attachment" "hvnat_vnic" {
  count       = "3"
  instance_id = "${element(var.instance_ocids, count.index%3)}"
  nic_index   = "1"

  create_vnic_details {
    subnet_id              = "${element(var.hyperv_subnet_ocids, count.index%3)}"
    assign_public_ip       = true
    display_name           = "BM Instance ${count.index + 1} hvnat vnic"
    skip_source_dest_check = true
  }

  depends_on = ["oci_core_vnic_attachment.bm_vnic_2"]
}

resource "oci_core_vnic_attachment" "hvrouter_vnic" {
  count       = "3"
  instance_id = "${element(var.instance_ocids, count.index%3)}"
  nic_index   = "1"

  create_vnic_details {
    subnet_id              = "${element(var.hyperv_subnet_ocids, count.index%3)}"
    assign_public_ip       = true
    display_name           = "BM Instance ${count.index + 1} hvrouter vnic"
    skip_source_dest_check = true
  }

  depends_on = ["oci_core_vnic_attachment.bm_vnic_2"]
}
