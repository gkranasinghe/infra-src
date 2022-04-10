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
    command     = " ansible-playbook -i ${self.name},  k8s-worker-playbook.yaml -e \" ansible_python_interpreter=/usr/bin/python3  hosttempfile_location=$PWD\" -vv "
    on_failure = fail
  }


}

resource "lxd_container" "nfsserver" {
  count = var.master_count
  name  = "nfsserver${count.index}"
  
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
      "ipv4.address" = "10.150.19.3${count.index}"
    }
  }


  limits = {
    cpu = 2
  }
  provisioner "local-exec" {


    working_dir = var.ansible_dir
    command     = "ansible-playbook -i ${self.name},    k8s-nfs-playbook.yaml -e \"ansible_python_interpreter=/usr/bin/python3  hosttempfile_location=$PWD\" -vv "
    # on_failure = fail
  }



}

resource "local_file" "inventory" {
  filename = "${var.ansible_dir}/inventory/hosts"
  
      content = <<EOT
# inventory/hosts      
[master_nodes]
${lxd_container.master[0].name}    ip_address=${tolist(lxd_container.master[0].device)[0].properties["ipv4.address"]}

[worker_nodes]
${lxd_container.worker[0].name}    ip_address=${tolist(lxd_container.worker[0].device)[0].properties["ipv4.address"]}
${lxd_container.worker[1].name}    ip_address=${tolist(lxd_container.worker[1].device)[0].properties["ipv4.address"]}

[nfs_nodes]
${lxd_container.nfsserver[0].name}    ip_address=${lxd_container.nfsserver[0].ipv4_address}



[all:vars]
ansible_connection=lxd
ansible_python_interpreter=/usr/bin/python3
hosttempfile_location=~/

EOT

   
}

//TODO null resource with patch playbook via local-exec

