variable "compartment_ocid" {}
variable "instance_shape" {}

variable "instance_image_ocid" {
  type = "map"
}

variable "hyperv_subnet_1_ocid" {}

variable "hyperv_subnet_2_ocid" {}

variable "hyperv_subnet_3_ocid" {}

variable "bm_subnet_1_ocid" {}

variable "bm_subnet_2_ocid" {}

variable "bm_subnet_3_ocid" {}

variable "region" {}
variable "tenancy_ocid" {}

data "oci_identity_availability_domains" "ADs" {
  compartment_id = "${var.tenancy_ocid}"
}

resource "oci_core_instance" "bm_instance_1" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "TF BM Instance 1"
  shape               = "${var.instance_shape}"
  subnet_id           = "${var.bm_subnet_1_ocid}"

  create_vnic_details {
    subnet_id        = "${var.bm_subnet_1_ocid}"
    display_name     = "BM Instance 1 VNIC"
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
  instance_id = "${oci_core_instance.bm_instance_1.id}"
  nic_index   = "1"

  create_vnic_details {
    subnet_id        = "${var.hyperv_subnet_1_ocid}"
    assign_public_ip = true
    display_name     = "BM Instance 1 VNIC 2"
  }
}

resource "oci_core_vnic_attachment" "hvnat_vnic" {
  instance_id = "${oci_core_instance.bm_instance_1.id}"
  nic_index   = "1"

  create_vnic_details {
    subnet_id              = "${var.hyperv_subnet_1_ocid}"
    assign_public_ip       = true
    display_name           = "instance 1 hvnat vnic"
    skip_source_dest_check = true
  }

  depends_on = ["oci_core_vnic_attachment.bm_vnic_2"]
}

resource "oci_core_vnic_attachment" "hvrouter_vnic" {
  instance_id = "${oci_core_instance.bm_instance_1.id}"
  nic_index   = "1"

  create_vnic_details {
    subnet_id              = "${var.hyperv_subnet_1_ocid}"
    assign_public_ip       = true
    display_name           = "instance 1 hvrouter vnic"
    skip_source_dest_check = true
  }

  depends_on = ["oci_core_vnic_attachment.bm_vnic_2"]
}

resource "oci_core_instance" "bm_instance_2" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[1],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "TF BM Instance 2"
  shape               = "${var.instance_shape}"
  subnet_id           = "${var.bm_subnet_2_ocid}"

  create_vnic_details {
    subnet_id        = "${var.bm_subnet_2_ocid}"
    display_name     = "BM Instance 2 VNIC"
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

resource "oci_core_vnic_attachment" "bm_vnic_3" {
  instance_id = "${oci_core_instance.bm_instance_2.id}"
  nic_index   = "1"

  create_vnic_details {
    subnet_id        = "${var.hyperv_subnet_2_ocid}"
    assign_public_ip = true
    display_name     = "BM Instance 2 VNIC 2"
  }
}

resource "oci_core_vnic_attachment" "hvnat_vnic_2" {
  instance_id = "${oci_core_instance.bm_instance_1.id}"
  nic_index   = "1"

  create_vnic_details {
    subnet_id              = "${var.hyperv_subnet_2_ocid}"
    assign_public_ip       = true
    display_name           = "instance 2 hvnat vnic"
    skip_source_dest_check = true
  }

  depends_on = ["oci_core_vnic_attachment.bm_vnic_3"]
}

resource "oci_core_vnic_attachment" "hvrouter_vnic_2" {
  instance_id = "${oci_core_instance.bm_instance_2.id}"
  nic_index   = "1"

  create_vnic_details {
    subnet_id              = "${var.hyperv_subnet_2_ocid}"
    assign_public_ip       = true
    display_name           = "instance 2 hvrouter vnic"
    skip_source_dest_check = true
  }

  depends_on = ["oci_core_vnic_attachment.bm_vnic_3"]
}

resource "oci_core_instance" "bm_instance_3" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[2],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "TF BM Instance 3"
  shape               = "${var.instance_shape}"
  subnet_id           = "${var.bm_subnet_3_ocid}"

  create_vnic_details {
    subnet_id        = "${var.bm_subnet_3_ocid}"
    display_name     = "BM Instance 3 VNIC"
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

resource "oci_core_vnic_attachment" "bm_vnic_4" {
  instance_id = "${oci_core_instance.bm_instance_3.id}"
  nic_index   = "1"

  create_vnic_details {
    subnet_id        = "${var.hyperv_subnet_3_ocid}"
    assign_public_ip = true
    display_name     = "BM Instance 2 VNIC 2"
  }
}

resource "oci_core_vnic_attachment" "hvnat_vnic_3" {
  instance_id = "${oci_core_instance.bm_instance_3.id}"
  nic_index   = "1"

  create_vnic_details {
    subnet_id              = "${var.hyperv_subnet_3_ocid}"
    assign_public_ip       = true
    display_name           = "instance 3 hvnat vnic"
    skip_source_dest_check = true
  }

  depends_on = ["oci_core_vnic_attachment.bm_vnic_4"]
}

resource "oci_core_vnic_attachment" "hvrouter_vnic_3" {
  instance_id = "${oci_core_instance.bm_instance_3.id}"
  nic_index   = "1"

  create_vnic_details {
    subnet_id              = "${var.hyperv_subnet_3_ocid}"
    assign_public_ip       = true
    display_name           = "instance 3 hvrouter vnic"
    skip_source_dest_check = true
  }

  depends_on = ["oci_core_vnic_attachment.bm_vnic_4"]
}
