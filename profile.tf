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