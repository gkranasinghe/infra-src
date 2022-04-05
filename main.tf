resource "lxd_network" "new_default" {
  name = "new_default"

  config = {
    "ipv4.address" = "10.150.19.1/24"
    "ipv4.nat"     = "true"
    "ipv6.address" = "fd42:474b:622d:259d::1/64"
    "ipv6.nat"     = "true"
  }
}

resource "lxd_profile" "profile1" {
  name = "profile1"

  config = {
    "limits.cpu"           = "2"
    "limits.memory"        = "2GB"
    "limits.memory.swap"   = "false"
    "linux.kernel_modules" = "ip_tables,ip6_tables,nf_nat,overlay,br_netfilter"
    "raw.lxc"              = "lxc.mount.entry = /dev/kmsg dev/kmsg none defaults,bind,create=file\nlxc.apparmor.profile=unconfined\nlxc.cap.drop=\nlxc.cgroup.devices.allow=a\nlxc.mount.auto=proc:rw sys:rw"
    "security.nesting"     = "true"
    "security.privileged"  = "true"
  }

  device {
    name = "eth0"
    type = "nic"

    properties = {
      nictype = "bridged"
      parent  = "${lxd_network.new_default.name}"
    }
  }

  device {
    type = "disk"
    name = "root"

    properties = {
      pool = "default"
      path = "/"
    }
  }
}

resource "lxd_container" "test1" {
  name      = "test1"
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
      "ipv4.address" = "10.150.19.10"
    }
  }


  limits = {
    cpu = 2
  }
  provisioner "local-exec" {
    
    
    working_dir = "./ansible/"
    command    = "ansible-playbook   playbook.yaml"
    # on_failure = fail
  }

}