resource "azurerm_network_interface" "vm" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "kali" {
  name                  = "${var.prefix}-kali"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  size                  = var.vm_size
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.vm.id]

  #key only SSH
  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  disable_password_authentication = true #this kills SSH password auth. note this doesn't touch xRDP/PAM

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = var.os_disk_size_gb
  }

  #which image to boot
  source_image_reference {
    publisher = "kali-linux"
    offer     = "kali"
    sku       = var.kali_sku
    version   = "latest"
  }

  plan {
    name      = var.kali_sku
    publisher = "kali-linux"
    product   = "kali"
  }

  #this is the first boot provisioning payload. Azure requires Base64-encoded.
  custom_data = base64encode(templatefile("${path.module}/cloud-init.yaml", {
    admin_username = var.admin_username

    firefox_bookmarks_json = jsonencode([
      for b in local.firefox_bookmarks : {
        Title     = b.title
        URL       = b.url
        Placement = b.placement
        Folder    = b.folder
      }
    ])

    torbrowser_bookmarks_json = jsonencode([
      for b in local.torbrowser_bookmarks : {
        Title     = b.title
        URL       = b.url
        Placement = b.placement
        Folder    = b.folder
      }
    ])
  }))
  tags       = var.tags
  depends_on = [azurerm_marketplace_agreement.kali]
}