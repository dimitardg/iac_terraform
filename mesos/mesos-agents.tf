variable "agents_vms_count" {
  default 		= 3
}

resource "libvirt_volume" "agents_data_disks" {
  pool 			= "nfsdatastore"
  format		= "raw"
  name			= "mesos_agent__0${count.index}.raw"
  size			= 25769803776
  count			= "${var.agents_vms_count}"
}

resource "libvirt_volume" "agents_ubuntu2004_boot_disk" {
  name			= "mesos-worker-0${count.index}.raw"
  base_volume_id	= "${module.ubuntu.ubuntu_2004_id[0]}"
  pool			= "nfsbootstore"
  count			= "${var.agents_vms_count}"
  size			= 25769803776
}

resource "libvirt_domain" "mesos_agent_s" {
  name			= "mesos-worker-0${count.index}.kd.local"
  memory		= 8192
  vcpu			= 6
  count			= "${var.agents_vms_count}"
  cloudinit		= "${module.cloudinit.cloudinit_id}"

  network_interface {
    bridge	= "br0"
  }

  // the bood disk
  disk {
    volume_id 		= "${element(libvirt_volume.agents_ubuntu2004_boot_disk.*.id, count.index)}"
  }

  // the data disks
  disk {
    volume_id 		= "${element(libvirt_volume.agents_data_disks.*.id, count.index)}"
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

output "agents_ips" {
  value = "${libvirt_domain.mesos_agent_s.*.network_interface.0.addresses}"
}

