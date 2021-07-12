variable "image" {
  type		= map(any)
  description	= "image for container"
  default = {
    dns = {
      docker_prod_00	= "internetsystemsconsortium/bind9:9.16"
      docker_prod_01	= "internetsystemsconsortium/bind9:9.16"
    }
    docker_registry = {
      docker_prod_00	= "registry:2"
      docker_prod_01	= "registry:2"
    }
  }
}

variable "ext_port" {
  type		= map(any)
  default = {
    dns = {
      docker_prod_00	= 53
      docker_prod_01	= 53
    }
    docker_registry = {
      docker_prod_00	= 5000
      docker_prod_01	= 5000
    }
  }
}

variable "int_port" {
  type		= map(any)
}

variable "docker_hosts" {
  type		= map(any)
  description	= "the ip addresses of docker hosts where containers needs to be deployed"
  default = {
    docker_prod_00	= "192.168.1.33"
    docker_prod_01	= "192.168.1.36"
  }
}
