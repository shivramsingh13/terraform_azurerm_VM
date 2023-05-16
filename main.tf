resource "azurerm_resource_group" "rg-1" {
  name = var.rg_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet-1" {
  name = var.vnet_name
  resource_group_name = azurerm_resource_group.rg-1.name
  location = azurerm_resource_group.rg-1.location
  address_space = ["10.0.0.0/16"]
}
resource "azurerm_subnet" "subnet-1" {
    name = var.subnet_name
    address_prefixes = ["10.0.1.0/24"]
    virtual_network_name = azurerm_virtual_network.vnet-1.name
  }

resource "azurerm_public_ip" "public_ip" {
  name = var.public_name
  resource_group_name = azrerm_resource_group.rg-1.name
  location = azurerm_resource_group.rg-1.location
  allocation_method = "Dyanamic"
}

  resource "azurerm_network_interface" "nic-1" {
    name = var.nic_name
    resouce_group_name = azurerm_resource_group.rg-1.name
    location = azrerm_resource_group.rg-1.location
    ip_configuration {
      name = "internal"
      subnet_id = azurerm_subnet.subnet-1.id
      private_ip_address_allocation = "Dyanamic"
      public_ip_address_id = "azurerm_public_ip.public_ip.id
  }
}

