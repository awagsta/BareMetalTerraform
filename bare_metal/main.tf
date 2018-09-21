provider "oci" {
  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid    = "${var.user_ocid}"
  fingerprint  = "${var.fingerprint}"
  region       = "${var.region}"
}

module "vcn" {
  source           = "./modules/vcn"
  user_ocid        = "${var.user_ocid}"
  tenancy_ocid     = "${var.tenancy_ocid}"
  compartment_ocid = "${var.compartment_ocid}"
  fingerprint      = "${var.fingerprint}"
  region           = "${var.region}"
  AD               = "${var.AD}"
}

module "compute" {
  source              = "./modules/compute"
  compartment_ocid    = "${var.compartment_ocid}"
  instance_shape      = "${var.instance_shape}"
  instance_image_ocid = "${var.instance_image_ocid}"
  bm_subnet_ocid      = "${module.vcn.bm_subnet_ocid}"
  hyperv_subnet_ocid  = "${module.vcn.hyperv_subnet_ocid}"
  AD                  = "${var.AD}"
  region              = "${var.region}"
  tenancy_ocid        = "${var.tenancy_ocid}"
}
