# Storage Firewall

variable "network_rules_enabled" {
  description = "Boolean to enable Network Rules on the Storage Account, requires `network_bypass`, `allowed_cidrs`, `subnet_ids` or `default_firewall_action` correctly set if enabled."
  type        = bool
  default     = true
}

variable "network_bypass" {
  description = "Specifies whether traffic is bypassed for 'Logging', 'Metrics', 'AzureServices' or 'None'."
  type        = list(string)
  default     = ["Logging", "Metrics", "AzureServices"]
}

variable "allowed_cidrs" {
  description = "List of CIDR to allow access to that Storage Account."
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "Subnets to allow access to that Storage Account."
  type        = list(string)
  default     = []
}

variable "default_firewall_action" {
  description = "Which default firewalling policy to apply. Valid values are `Allow` or `Deny`."
  type        = string
  default     = "Deny"
}
############  Private Endpoint ############
variable "enable_private_endpoint" {
  description = "Boolean to enable private endpoint connection for the storage account. This template only enable blob sub resource"
  type        = bool
  default     = true
}

variable "private_dns_zone_blob_id" {
  description = "Private DNS Zone Id for Blob"
  type        = string
}

variable "private_endpoint_subnet_id" {
  description = "Subnet Id the private endpoint is associated with. Mandatory if private endpoint is used"
  type        = string
  default     = null
}