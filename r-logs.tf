module "diagnostics" {
    source  = "app.terraform.io/fabbuildingblocks/diagnostics-settings/azurerm"
    version = "0.1.2"
    resource_id = azurerm_storage_account.storage.id    
    logs_destinations_ids = var.logs_destinations_ids
    log_categories        = var.logs_categories
    metric_categories     = var.logs_metrics_categories
    retention_days        = var.logs_retention_days 
    custom_name    = var.custom_diagnostic_settings_name
}

#module "diagnostics_type" {
#  for_each = toset(["blob", "file", "table", "queue"])
#
#    source  = "app.terraform.io/fabbuildingblocks/diagnostics-settings/azurerm"
#    version = "0.1.2"
#
#    resource_id = format("%s/%sServices/default/", azurerm_storage_account.storage.id, each.key)
#
#    logs_destinations_ids = var.logs_destinations_ids
#    log_categories        = var.logs_categories
#    metric_categories     = var.logs_metrics_categories
#    retention_days        = var.logs_retention_days
#    custom_name    = var.custom_diagnostic_settings_name
#}
