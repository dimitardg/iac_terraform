locals {
  deployment = {
    dns = {
      container_count	= length(var.ext_port["dns"][terraform.workspace])
      image		= var.image["dns"][terraform.workspace]
      int		= 53
      ext		= var.ext_port["dns"][terraform.workspace]
      volumes = [
	{ container_path_each = "/etc/bind" },
     ]
    },
    docker_registry = {
      container_count	= length(var.ext_port["docker_registry"][terraform.workspace])
      image		= var.image["docker_registry"][terraform.workspace]
      int		= 5000
      ext		= var.ext_port["docker_registry"][terraform.workspace]
      volumes = [
        { container_path_each = "/var/lib/registry" },
      ]
    }
  }
}
