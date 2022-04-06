resource "lxd_network" "new_default" {
  name = "new_default"

  config = {
    "ipv4.address" = var.lxd_cidr
    "ipv4.nat"     = "true"
    "ipv6.address" = "fd42:474b:622d:259d::1/64"
    "ipv6.nat"     = "true"
  }
}