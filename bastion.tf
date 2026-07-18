# bastion.tf is our managed jump host. 
resource "azurerm_public_ip" "bastion" {
  name                = "${var.prefix}-bastion-pip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static" # Bastion requires both. this is non negotiable 
  sku                 = "Standard"
  tags                = var.tags
}
resource "azurerm_bastion_host" "main" {
  name                = "${var.prefix}-bastion"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard" # standard unlocks Linux RDP and native client tunneling... Basic does neither
  tunneling_enabled   = true       # native client tunneling 
  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
  tags = var.tags
}