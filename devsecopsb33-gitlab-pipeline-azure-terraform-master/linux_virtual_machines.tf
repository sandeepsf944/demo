# Create Virtual Machines public-ip
resource "azurerm_public_ip" "vms" {
  count               = 3 # 0 1 2
  name                = "linuxvm-pip-${count.index}"
  location            = azurerm_resource_group.DevSecOps33.location
  resource_group_name = azurerm_resource_group.DevSecOps33.name
  allocation_method   = "Dynamic"

  tags = {
    Environment = "Development"
    Batch       = "DevSecOps33"
  }
}

# Create Virtual Machine Network Interface
resource "azurerm_network_interface" "vms" {
  count               = 3
  name                = "linuxvm-nic-${count.index}"
  location            = azurerm_resource_group.DevSecOps33.location
  resource_group_name = azurerm_resource_group.DevSecOps33.name
  ip_configuration {
    name                          = "vms-ipconfig-${count.index}"
    subnet_id                     = element(azurerm_subnet.subnets.*.id, count.index)
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.vms.*.id, count.index)
  }
  tags = {
    Environment = "Development"
    Batch       = "DevSecOps33"
  }
}

# Create Virtual Machines
resource "azurerm_linux_virtual_machine" "vms" {
  count               = 3
  name                = "${azurerm_resource_group.DevSecOps33.name}-vm-${count.index + 1}"
  resource_group_name = azurerm_resource_group.DevSecOps33.name
  location            = azurerm_resource_group.DevSecOps33.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = random_password.linux-machine-1.result
  #admin_password                  = element(azurerm_key_vault_secret.vm-passwords.*.value, count.index)
  #admin_password                  = data.vault_generic_secret.linux_creds.data["password"]
  disable_password_authentication = false
  network_interface_ids = [
    element(azurerm_network_interface.vms.*.id, count.index)
  ]
  depends_on = [azurerm_key_vault_access_policy.devsecopsb33-sp-access]
  os_disk {
    name                 = "vm${count.index + 1}OSDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = "30"
  }
  identity {
    type = "SystemAssigned"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal-daily"
    sku       = "20_04-daily-lts-gen2"
    version   = "latest"
  }
}