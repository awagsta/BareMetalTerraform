# Bare metal terraform
Terraform Scripts to instantiate a bare metal instance and associated VNICS and subnets.

This script instantiates a bare metal server and the associated networking.
An entry to the route table must be added manually from the hvnat vnic's private ip to your hyper-v address cidr.
