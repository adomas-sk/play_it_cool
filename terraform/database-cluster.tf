resource "digitalocean_database_cluster" "default_postgres" {
  name       = "default-postgres-cluster"
  engine     = "pg"
  version    = "11"
  size       = "db-s-1vcpu-1gb"
  region     = "fra1"
  node_count = 1
  # private_network_uuid = digitalocean_vpc.default.id
}

output "database_uri" {
  value = digitalocean_database_cluster.default_postgres.uri
}
