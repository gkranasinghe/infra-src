
resource "lxd_profile" "profile3" {
  name = "profile3"

  config = {
    "limits.cpu"           = "4"
    "limits.memory"        = "6GB"
    "limits.memory.swap"   = "false"
    "linux.kernel_modules" = "ip_tables,ip6_tables,nf_nat,overlay,br_netfilter,rbd,zfs"
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


  device {
    name = "volume1"
    type = "disk"
    properties = {
      path   = "/mount/point/in/container"
      source = "${lxd_volume.volume1.name}"
      pool   = "${lxd_storage_pool.pool1.name}"
    }
  }
  device {
    name = "nvme0n1p6"
    type = "unix-block"
    properties = {
      path   = "/mount/point/in/container"
      source = "/dev/nvme0n1p6"
      path   = "/mnt/nvme0n1p6"
    }
  }
}