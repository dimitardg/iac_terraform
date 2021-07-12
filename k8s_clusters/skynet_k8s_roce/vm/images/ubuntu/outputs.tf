output "ubuntu_2004_id" {
  value = "${libvirt_volume.ubuntu_2004_vol.*.id}"
}
