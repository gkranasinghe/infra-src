
# resource "lxd_storage_pool" "nfs-pool" {
#   name   = "nfs-pool"

#   driver = "zfs"
#   config = {
#     source = "/dev/disk/by-id/nvme-Micron_2200V_MTFDHBA512TCK__19402444B82D-part7"
#   }
# }

# ls -l /dev/disk/by-id/
# lxc storage create zfs-pool zfs volatile.initial_source=/dev/disk/by-id/nvme-Micron_2200V_MTFDHBA512TCK__19402444B82D-part5
