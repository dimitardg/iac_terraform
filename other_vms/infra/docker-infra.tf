module "cloudinit" {
  source		= "./vm/images/cloudinit"
  unique_name		= "ubuntu_2004_services_cloudinit.iso"
  cloudinit_filename 	= "cloud_init_default.cfg"
}

module "ubuntu" {
  source		= "./vm/images/ubuntu"
  pool			= "nfsbootstore"
}

variable "services_vms_count" {
  default 		= 2
}

resource "libvirt_volume" "services_data_disks" {
  pool 			= "nfsdatastore"
  format		= "raw"
  name			= "services_0${count.index}.raw"
  size			= 25769803776
  count			= "${var.services_vms_count}"
}

resource "libvirt_volume" "services_ubuntu2004_boot_disk" {
  name			= "services-0${count.index}.raw"
  base_volume_id	= "${module.ubuntu.ubuntu_2004_id[0]}"
  pool			= "nfsbootstore"
  count			= "${var.services_vms_count}"
  size			= 25769803776
}

resource "libvirt_domain" "services_vm" {
  name			= "services-0${count.index}.kd.local"
  memory		= 2048
  vcpu			= 2
  count			= "${var.services_vms_count}"
  cloudinit		= "${module.cloudinit.cloudinit_id}"

  network_interface {
    bridge		= "br0"
  }

  // the bood disk
  disk {
    volume_id 		= "${element(libvirt_volume.services_ubuntu2004_boot_disk.*.id, count.index)}"
  }

  // the data disks
  disk {
    volume_id 		= "${element(libvirt_volume.services_data_disks.*.id, count.index)}"
  }

  console {
    type		= "pty"
    target_type		= "virtio"
    target_port		= 1
  }

  graphics {
    type		= "spice"
    listen_type		= "address"
    autoport		= true
  }
}

output "services_ips" {
  value = "${libvirt_domain.services_vm.*.network_interface.0.addresses}"
}
