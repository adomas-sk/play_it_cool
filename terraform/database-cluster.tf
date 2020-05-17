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

# resource "digitalocean_database_connection_pool" "pool-01" {
#   cluster_id = digitalocean_database_cluster.default_postgres.id
#   name       = "pool-01"
#   mode       = "transaction"
#   size       = 20
#   db_name    = "defaultdb"
#   user       = "doadmin"
# }

# output "connection_pool_uri" {
#   value = digitalocean_database_connection_pool.pool-01.private_uri
# }
