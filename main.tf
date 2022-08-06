resource "lxd_container" "master" {

  count = var.master_count
  name  = "master${count.index}"

  image     = "ubuntu:20.04"
  ephemeral = false
  profiles  = ["${lxd_profile.profile0.name}"]

  config = {
    "boot.autostart" = false
  }
  device {
    name = "eth0"
    type = "nic"

    properties = {
      nictype        = "bridged"
      parent         = "${lxd_network.new_default.name}"
      "ipv4.address" = "10.150.19.1${count.index}"
    }
  }


  limits = {
    cpu = 2
  }


  provisioner "local-exec" {


    working_dir = var.ansible_dir
    command     = " ansible-playbook -i ${self.name},  k8s-master-playbook.yaml -e \" ansible_python_interpreter=/usr/bin/python3  hosttempfile_location=$PWD\" -vv "
    # on_failure = fail
  }


}

resource "lxd_container" "worker" {
  depends_on = [
    lxd_container.master
  ]
  count = var.worker_count
  name  = "worker${count.index}"

  image     = "ubuntu:20.04"
  ephemeral = false

  profiles = distinct([count.index == 0 ? "profile1" : "profile0", count.index == 1 ? "profile2" : "profile0", count.index == 2 ? "profile3" : "profile0"])

  config = {
    "boot.autostart" = false
  }
  device {
    name = "eth0"
    type = "nic"

    properties = {
      nictype        = "bridged"
      parent         = "${lxd_network.new_default.name}"
      "ipv4.address" = "10.150.19.2${count.index}"
    }
  }


  # limits = {
  #   cpu = 8,
  #   memory =  "12288MB"

  # }

  provisioner "local-exec" {


    working_dir = var.ansible_dir
    command     = " ansible-playbook -i ${self.name},master0  k8s-worker-playbook.yaml -e \" ansible_python_interpreter=/usr/bin/python3  hosttempfile_location=$PWD\" -vv "
    on_failure  = fail
  }


}

resource "lxd_container" "nfs" {
  depends_on = [
    lxd_container.master
  ]

  count = var.nfs_count
  name  = "nfsserver${count.index}"

  image     = "ubuntu:20.04"
  ephemeral = false
  profiles  = ["${lxd_profile.nfs-server.name}"]

  config = {
    "boot.autostart" = false
  }
  device {
    name = "eth0"
    type = "nic"

    properties = {
      nictype        = "bridged"
      parent         = "${lxd_network.new_default.name}"
      "ipv4.address" = "10.150.19.3${count.index}"
    }
  }


  limits = {
    cpu = 2
  }


  






}

resource "null_resource" "nfs_source" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    nfs_source = var.nfs_source
  }
  provisioner "local-exec" {
    working_dir = var.ansible_dir
    command     = " ansible-playbook -i nfsserver0,  k8s-nfs-playbook.yaml -e \" ansible_python_interpreter=/usr/bin/python3 nfs_source=${var.nfs_source} hosttempfile_location=$PWD\" -vv "
    # on_failure = fail
  }
  

}

