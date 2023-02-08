# Basic Storage Account and Blob Container
This is an example for setting-up a Storage account and two blob containers
 This examples creates
  - Sets the different Azure Region representation ( location, location_short, location_cli ...) --> module "regions_master"
  - Instanciates a map object with the common Tags ot be applied to all resources --> module "base_tagging"
  - A resource-group --> module "ressource" 
  - Creates a storage account  
  - Creates two blob containers  
  - Creates a private endpoint for Blob  
  - Set the default diagnostics settings (All Logs and metric) whith a Log Analytics workspace as destination 

| The Subnet and Private DNS zone for the private endpoint are not created by this module 

## Main.tf file content
  Please replace the modules source and version with your relevant information  
  Variables.tf and the associated tfvars files are not described here but must be defined 

```hcl
// Core modules

module "regions_master" {
  source  = "app.terraform.io/<ORGANIZATION>/regions-master/azurem"
  version = "x.y.z"
  azure_region = var.location # example eu-west
}

module "base_tagging" {
  source  = "app.terraform.io/<ORGANIZATION>/base-tagging/azurerm"
  version = "x.y.z"
  environment = var.environment
  stack = var.stack
  spoc =  var.spoc
  change = var.change
  costcenter = var.costcenter
  owner = var.owner
}

// Resource Group
module "ressource" {
    source  = "app.terraform.io/<ORGANIZATION>/rg/azurerm"
    version = "x.y.z"
    environment = var.environment
    stack       = var.stack
    location    = module.regions_master.location
    location_short = module.regions_master.location_short
}

module "storage_account" {
  source  = "app.terraform.io/<ORGANIZATION>/blob-storage/azurerm"
  version = "x.y.z"
  environment = var.environment
  landing_zone_slug = var.landing_zone_slug
  stack       = var.stack
  location                        = module.regions_master.location
  location_short                  = module.regions_master.location_short
  resource_group_name             = module.rg.resource_group_name
  default_tags                    = module.base-tagging.base_tags

  logs_destinations_ids = var.logs_destinations_ids

  private_dns_zone_ids = var.private_dns_zone_blob
  private_dns_zone_blob_id = var.private_endpoint_blob_id

  containers = [
    {
      name = "containerone"
    },
    {
      name = "containertwo"
    }
  ]
}
```