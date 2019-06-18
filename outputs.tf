output "Aurora Cluster Endpoint" {
  value ="${module.db.this_rds_cluster_endpoint}"
}


output "Aurora Cluster Reader Endpoint" {
  value ="${module.db.this_rds_cluster_endpoint}"
}