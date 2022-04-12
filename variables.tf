variable "master_count" {
  type    = number
  default = 1
}
variable "worker_count" {
  type    = number
  default = 3
}

# variable "nfs_count" {
#   type    = number
#   default = 1
# }

variable "lxd_cidr" {
  type    = string
  default = "10.150.19.1/24"
}


variable "ansible_dir" {
  type    = string
  default = "./ansible/"
}