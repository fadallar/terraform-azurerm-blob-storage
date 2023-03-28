resource "azurerm_user_assigned_identity" "blob_data_contributor" {
  location            = var.location
  name                = format("id-blob-data-contributor-%s", azurerm_storage_account.this.name)
  resource_group_name = var.resource_group_name
  tags                = var.default_tags
}

resource "azurerm_role_assignment" "blob_data_contributor" {
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.blob_data_contributor.principal_id
}