provider "oci" {
  tenancy_ocid     = "${var.tenancy_ocid}"
  user_ocid        = "${var.user_ocid}"
  fingerprint      = "${var.fingerprint}"
  region           = "${var.region}"
  private_key_path = "${var.ssh_private_key_path}"
}

module "vcn" {
  source           = "./modules/vcn"
  user_ocid        = "${var.user_ocid}"
  tenancy_ocid     = "${var.tenancy_ocid}"
  compartment_ocid = "${var.compartment_ocid}"
  fingerprint      = "${var.fingerprint}"
  region           = "${var.region}"
}

module "compute" {
  source               = "./modules/compute"
  compartment_ocid     = "${var.compartment_ocid}"
  instance_shape       = "${var.instance_shape}"
  instance_image_ocid  = "${var.instance_image_ocid}"
  bm_subnet_1_ocid     = "${module.vcn.bm_subnet_1_ocid}"
  bm_subnet_2_ocid     = "${module.vcn.bm_subnet_2_ocid}"
  bm_subnet_3_ocid     = "${module.vcn.bm_subnet_3_ocid}"
  hyperv_subnet_1_ocid = "${module.vcn.hyperv_subnet_1_ocid}"
  hyperv_subnet_2_ocid = "${module.vcn.hyperv_subnet_2_ocid}"
  hyperv_subnet_3_ocid = "${module.vcn.hyperv_subnet_3_ocid}"
  region               = "${var.region}"
  tenancy_ocid         = "${var.tenancy_ocid}"
}
