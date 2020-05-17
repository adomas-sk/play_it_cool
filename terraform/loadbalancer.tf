resource "digitalocean_loadbalancer" "www-lb" {
  name   = "web-lb"
  region = "fra1"

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "tcp"

    target_port     = 80
    target_protocol = "tcp"
  }

  healthcheck {
    port     = 22
    protocol = "tcp"
  }

  droplet_ids = [digitalocean_droplet.playitcool-1.id]

  # vpc_uuid = digitalocean_vpc.default.id
}
