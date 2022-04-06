# locals {
#   nodes  =  [for n in range(var.worker_count) : "${lxd_container.worker[n].ipv4_address} is ${n}"]
  

# }

resource "lxd_container" "master" {
  count = var.master_count
  name  = "master${count.index}"
  
  image     = "ubuntu:20.04"
  ephemeral = false
  profiles  = ["${lxd_profile.profile1.name}"]

  config = {
    "boot.autostart" = true
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
    command     = "ansible-playbook   playbook.yaml"
    # on_failure = fail
  }


}

resource "lxd_container" "worker" {
  count = var.worker_count
  name  = "worker${count.index}"
  
  image     = "ubuntu:20.04"
  ephemeral = false
  profiles  = ["${lxd_profile.profile1.name}"]

  config = {
    "boot.autostart" = true
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


  limits = {
    cpu = 2
  }
  provisioner "local-exec" {


    working_dir = var.ansible_dir
    command     = "ansible-playbook   playbook.yaml"
    # on_failure = fail
  }


}



resource "local_file" "inventory" {
  filename = "ansible/inventory/hosts"
  
      content = <<EOT
# inventory/hosts      
[master_nodes]
${lxd_container.master[0].name}    ip_address=${lxd_container.master[0].ipv4_address}


[worker_nodes]
${lxd_container.worker[0].name}    ip_address=${lxd_container.worker[0].ipv4_address}
${lxd_container.worker[1].name}    ip_address=${lxd_container.worker[1].ipv4_address}

[all:vars]
ansible_connection=lxd
ansible_python_interpreter=/usr/bin/python3
hosttempfile_location=/home/gk

EOT

   
}
