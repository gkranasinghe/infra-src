
resource "lxd_storage_pool" "pool1" {
  name   = "mypool"
  driver = "zfs"
  config = {
    source = "/dev/nvme0n1p4"
  }
}

resource "lxd_volume" "volume1" {
  name = "myvolume"
  pool = lxd_storage_pool.pool1.name
}

# resource "lxd_storage_pool" "zfspool_worker2" {
#   target = "worker2"

#   name = "zfspool0"
#   driver = "zfs"
#   config = {
#     source = "/dev/nvme0n1p4"
#   }
# }

# # resource "lxd_storage_pool" "zfspool0" {
# #   depends_on = [
# #     lxd_storage_pool.zfspool_worker1,
# #     lxd_storage_pool.zfspool_worker2,
# #   ]

# #   name = "zfspool0"
# #   driver = "zfs"

# # }