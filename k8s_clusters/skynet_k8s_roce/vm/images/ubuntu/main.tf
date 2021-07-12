resource "libvirt_volume" "ubuntu_2004_vol" {
  name		= "ubuntu-20.04-server-cloudimg-amd64.img"
  source 	= "https://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64.img"
  count		= 1
  pool		= "${var.pool}"
}
