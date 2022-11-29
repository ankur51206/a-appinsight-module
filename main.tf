# Create a resource group
resource "azurerm_resource_group" "rg-alkmy" {
  name     = "rg-alkmy"
  location = "eastus2"
}
# Create Subnet
module "onpremises_subnet" {
  source          = "./Subnet"
  MODVERSION      = "v2.0"
  APP_NAME        = local.app_lower
  APP_ENV         = local.env_lower
  LOCATION        = local.pri_loc
  SNET_TYPE       = "app"
  SNET_MASK       = "28"
  SNET_NAME       = "snet-onpremises-app"
  SNET_NSG_CREATE = "false"
}

# Create App Insights
module "app_insightsut" {
  for_each            = toset(local.def_onprem_name)
  source              = "./Insights"
  MODVERSION          = "v2.2"
  APP_NAME            = var.APP_NAME
  APP_ENV             = var.APP_ENV
  LOCATION            = local.pri_loc
  RESOURCE_GROUP_NAME = azurerm_resource_group.rg-alkmy.name
  PRIVATE_SUBNET_ID   = module.onpremises_subnet.id
  INSIGHTS_NAME       = "appi-${each.value}"
  INSIGHTS_TYPE       = "web"
}
