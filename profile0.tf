
resource "lxd_profile" "profile0" {
  name = "profile0"

  config = {

    "limits.cpu"           = "4"
    "limits.memory"        = "6GB"
    "limits.memory.swap"   = "false"
    "linux.kernel_modules" = "ip_tables,ip6_tables,nf_nat,overlay,br_netfilter,rbd,zfs,nfs"
    "raw.lxc"              = "lxc.mount.entry = /dev/kmsg dev/kmsg none defaults,bind,create=file\nlxc.apparmor.profile=unconfined\nlxc.cap.drop=\nlxc.cgroup.devices.allow=a\nlxc.mount.auto=proc:rw sys:rw"
    "security.nesting"     = "true"
    "security.privileged"  = "true"
    # GPU Passthrough config
    # "lxc.cgroup.devices.allow" = "c 195:* rwm"
    # "lxc.cgroup.devices.allow" = "c 506:* rwm"
    # "lxc.mount.entry" = "/dev/nvidia0 dev/nvidia0 none bind,optional,create=file"
    # "lxc.mount.entry" = "/dev/nvidiactl dev/nvidiactl none bind,optional,create=file"
    # "lxc.mount.entry" = "/dev/nvidia-uvm dev/nvidia-uvm none bind,optional,create=file"
    # "lxc.mount.entry" = "/dev/nvidia-modeset dev/nvidia-modeset none bind,optional,create=file"
    # "lxc.mount.entry" = "/dev/nvidia-uvm-tools dev/nvidia-uvm-tools none bind,optional,create=file"
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
