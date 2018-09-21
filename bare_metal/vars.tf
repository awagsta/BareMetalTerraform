variable "compartment_ocid" {
  description = "The ocid of the compartment to deploy in"
}

variable "tenancy_ocid" {
  description = "The ocid of the tenancy to deploy in"
}

variable "user_ocid" {
  description = "The ocid of the user"
}

variable "region" {
  description = "The region to deploy in"
}

variable "fingerprint" {
  description = "The fingerprint of the key to use"
}

variable "instance_image_ocid" {
  type = "map"

  default = {
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaaazomv4stgxzsvknokxv2dprak6q7jugzzozpqpjfuiuxks2afkfq"
    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaatach4vk7fk7wgwocr7fjunzwagz3bygj4mc7axajdokfwnuwsibq"
    us-phoenix-1   = "ocid1.image.oc1.phx.aaaaaaaa22s7v5slgeqohhu2qxaiiehd7q2mdu2y4ta2ggpuzyug3io3bcyq"
    uk-london-1    = "ocid1.image.oc1.uk-london-1.aaaaaaaawbhbkek3gto5z4ugupavd42b5tsvi6qoxagpffr3jjnqihvvsila"
  }

  description = "A map of the images to use by region"
}

variable "AD" {
  default = "2"
}

variable "instance_shape" {
  default = "BM.DenseIO2.52"
}

variable "ssh_private_key_path" {}
