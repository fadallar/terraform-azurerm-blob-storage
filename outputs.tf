#output "storage_account_properties" {
#  description = "Created Storage Account properties"
#  value       = azurerm_storage_account.storage
#}

output "storage_account_id" {
  description = "Created Storage Account ID"
  value       = azurerm_storage_account.this.id
}

output "storage_account_name" {
  description = "Created Storage Account name"
  value       = azurerm_storage_account.this.name
}

output "storage_account_identity" {
  description = "Created Storage Account identity block"
  value       = azurerm_storage_account.this.identity
}

#output "storage_account_network_rules" {
#  description = "Network rules of the associated Storage Account"
#  value       = one(azurerm_storage_account_network_rules.network_rules[*])
#}

#output "storage_blob_containers" {
#  description = "Created blob containers in the Storage Account"
#  value       = azurerm_storage_container.container
#}

#primary_location - The primary location of the storage account.
#secondary_location - The secondary location of the storage account.
#primary_blob_endpoint - The endpoint URL for blob storage in the primary location.
#primary_blob_host - The hostname with port if applicable for blob storage in the primary location.
#secondary_blob_endpoint - The endpoint URL for blob storage in the secondary location.
#secondary_blob_host - The hostname with port if applicable for blob storage in the secondary location.
#primary_queue_endpoint - The endpoint URL for queue storage in the primary location.
#primary_queue_host - The hostname with port if applicable for queue storage in the primary location.
#secondary_queue_endpoint - The endpoint URL for queue storage in the secondary location.
#secondary_queue_host - The hostname with port if applicable for queue storage in the secondary location.
#primary_table_endpoint - The endpoint URL for table storage in the primary location.
#primary_table_host - The hostname with port if applicable for table storage in the primary location.
#secondary_table_endpoint - The endpoint URL for table storage in the secondary location.
#secondary_table_host - The hostname with port if applicable for table storage in the secondary location.
#primary_file_endpoint - The endpoint URL for file storage in the primary location.
#primary_file_host - The hostname with port if applicable for file storage in the primary location.
#secondary_file_endpoint - The endpoint URL for file storage in the secondary location.
#secondary_file_host - The hostname with port if applicable for file storage in the secondary location.
#primary_dfs_endpoint - The endpoint URL for DFS storage in the primary location.
#primary_dfs_host - The hostname with port if applicable for DFS storage in the primary location.
#secondary_dfs_endpoint - The endpoint URL for DFS storage in the secondary location.
#secondary_dfs_host - The hostname with port if applicable for DFS storage in the secondary location.
#primary_web_endpoint - The endpoint URL for web storage in the primary location.
#primary_web_host - The hostname with port if applicable for web storage in the primary location.
#secondary_web_endpoint - The endpoint URL for web storage in the secondary location.
#secondary_web_host - The hostname with port if applicable for web storage in the secondary location.
#primary_access_key - The primary access key for the storage account.
#secondary_access_key - The secondary access key for the storage account.
#primary_connection_string - The connection string associated with the primary location.
#secondary_connection_string - The connection string associated with the secondary location.
#primary_blob_connection_string - The connection string associated with the primary blob location.
#secondary_blob_connection_string - The connection string associated with the secondary blob location.
#identity
