provider "docker" {
  host = "tcp://192.168.99.100:2375/"
}

resource "docker_image" "img-php" {
  name = "shekeriev/dob-w3-php"
}

resource "docker_image" "img-mysql" {
  name = "shekeriev/dob-w3-mysql"
}

resource "docker_network" "private_network" {
  name = "dob_network"
}

# Create a container
resource "docker_container" "dob-php" {
  name     = "dob-php"
  hostname = "dob-php"
  image    = docker_image.img-php.latest
  mounts {
    target    = "/var/www/html"
    source    = "/home/vagrant/two-docker-images/site"
    type      = "bind"
    read_only = "false"
  }
  networks_advanced {
    name = "dob_network"
  }
  ports {
    internal = "80"
    external = "80"
  }
}

resource "docker_container" "dob-mysql" {
  name     = "dob-mysql"
  hostname = "dob-mysql"
  env = [
    "MYSQL_ROOT_PASSWORD=12345",
    # "MYSQL_DATABASE=docker_info",
    # "MYSQL_USER=root",
    # "MYSQL_ROOT_HOST=dob-mysql"
  ]
  image = docker_image.img-mysql.latest
  networks_advanced {
    name = "dob_network"
  }
  ports {
    internal = "3306"
    external = "3306"
  }
}

#docker container run -d --name c-mysql -e MYSQL_ROOT_PASSWORD=12345 shekeriev/dob-w3-mysql
#docker container run -d --name c-php -p 80:80 -v /home/vagrant/two-docker-images/site:/var/www/html --link c-mysql:dob-mysql shekeriev/dob-w3-php

# Noted issues
# Firewall-cmd was blocking internal network connection
#   - Disable the firewall or allow the docker network
# Firewall deactivation will flush all iptables rules
#   - docker must be restarted in order to re-set his iptable rules/chains etc..