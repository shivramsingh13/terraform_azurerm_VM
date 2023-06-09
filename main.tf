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
    resource_group_name = azurerm_resource_group.rg-1.name
  }

resource "azurerm_public_ip" "public_ip" {
  name = var.public_name
  resource_group_name = azurerm_resource_group.rg-1.name
  location = azurerm_resource_group.rg-1.location
  allocation_method = "Dynamic"
}

resource "azurerm_network_interface" "nic-1" {
    name = var.nic_name
    resource_group_name = azurerm_resource_group.rg-1.name
    location = azurerm_resource_group.rg-1.location  
  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.subnet-1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.public_ip.id        
}
}

resource "azurerm_virtual_machine" "vm-1" {
    name = var.vm_name
    resource_group_name = azurerm_resource_group.rg-1.name
    location = azurerm_resource_group.rg-1.location
    vm_size = "Standard_F2"
    network_interface_ids = [azurerm_network_interface.nic-1.id]
    os_profile {
        computer_name = "hostname"
        admin_username = "adminuser"
        admin_password = "shiv@1234567"
    }
    os_profile_windows_config {

    }
    storage_os_disk {
        name = var.os_disk_name
        caching = "ReadWrite"
        create_option = "FromImage"
        managed_disk_type = "Standard_LRS"

    }
    storage_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer = "WindowsServer"
        sku = "2016-Datacenter"
        version = "latest"

    }
    }
resource "azurerm_managed_disk" "disk-2" {
    name = var.data_disk_name
    resource_group_name = azurerm_resource_group.rg-1.name
    location = azurerm_resource_group.rg-1.location
    storage_account_type = "Standard_LRS"
    create_option = "Empty"
    disk_size_gb = 30
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk-2" {
    managed_disk_id = azurerm_managed_disk.disk-2.id
    virtual_machine_id = azurerm_virtual_machine.vm-1.id
    lun = 10
    caching = "ReadWrite"
}
