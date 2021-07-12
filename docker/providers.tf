terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {
  host 	= "ssh://skynet@${var.docker_hosts[terraform.workspace]}"
}
