variable "workers_vms_count" {
  default 		= 3
}

resource "libvirt_volume" "workers_data_Disks" {
  pool 			= "nfsdatastore"
  format		= "raw"
  name			= "a_k8s_roce_worker_0${count.index}.raw"
  size			= 25769803776
  count			= "${var.workers_vms_count}"
}

resource "libvirt_volume" "workers_ubuntu2004_boot_disk" {
  name			= "a-k8s-roce-worker-0${count.index}.raw"
  base_volume_id	= "${module.ubuntu.ubuntu_2004_id[0]}"
  pool			= "nfsbootstore"
  count			= "${var.workers_vms_count}"
  size			= 25769803776
}

resource "libvirt_domain" "a_k8s_roce_workers" {
  name			= "a-k8s-roce-worker-0${count.index}.kd.local"
  memory		= 8192
  vcpu			= 6
  count			= "${var.workers_vms_count}"
  cloudinit		= "${module.cloudinit.cloudinit_id}"

  network_interface {
    bridge	= "br0"
  }

  // the bood disk
  disk {
    volume_id 		= "${element(libvirt_volume.workers_ubuntu2004_boot_disk.*.id, count.index)}"
  }

  // the data disks
  disk {
    volume_id 		= "${element(libvirt_volume.workers_data_Disks.*.id, count.index)}"
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

output "workers_ips" {
  value = "${libvirt_domain.a_k8s_roce_workers.*.network_interface.0.addresses}"
}

