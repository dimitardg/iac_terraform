terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.6.9-pre4"
    }
  }
}

provider "libvirt" {
  uri                   = "qemu:///system"
}
