provider "azurerm" {
  features {
  }
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_static_web_app" "serviceApp" {
  location = azurerm_service_plan.appplan.location
  name = var.linux_web_app_name
  resource_group_name = azurerm_resource_group.rg.name

}
