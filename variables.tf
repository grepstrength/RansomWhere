# 1. NAMING & PLACEMENT
variable "prefix" {
  type        = string
  description = "Short lowercase prefix prepended to all resource names."
  default     = "ransomwhere"
  validation {
    condition     = can(regex("^[a-z0-9-]{3,12}$", var.prefix))
    error_message = "prefix must be 3-12 chars, lowercase letters, numbers, and hyphens only."
  }
}

variable "location" {
  type        = string
  description = "Azure region for all resources."
  default     = "eastus2"
}

# 2. NETWORKING 
variable "vnet_address_space" {
  type        = list(string)
  description = "CIDR blocks for the virtual network."
  default     = ["10.42.0.0/16"]
}

variable "vm_subnet_prefix" {
  type        = string
  description = "CIDR for the subnet holding the Kali VM. Will be a private subnet with no default outbound."
  default     = "10.42.1.0/24"
  validation {
    condition     = can(cidrhost(var.vm_subnet_prefix, 0))
    error_message = "vm_subnet_prefix must be a valid CIDR block, e.g. 10.42.1.0/24."
  }
}

variable "bastion_subnet_prefix" {
  type        = string
  description = "CIDR for AzureBastionSubnet. MUST be /26 or larger for dedicated Bastion SKUs."
  default     = "10.42.2.0/26"
  validation {
    condition     = tonumber(split("/", var.bastion_subnet_prefix)[1]) <= 26
    error_message = "AzureBastionSubnet must be /26 or larger (i.e. /26, /25, /24). Azure rejects /27 and smaller for dedicated SKUs."
  }
}

# 3. VIRTUAL MACHINE
variable "vm_size" {
  type        = string
  description = "Azure VM SKU. B2s is sufficient for slim Kali + XFCE + two browsers."
  default     = "Standard_B2s"
}

variable "os_disk_size_gb" {
  type        = number
  description = "OS disk size. The Kali image default (~30GB) is too small once XFCE and Tor Browser land."
  default     = 64

  validation {
    condition     = var.os_disk_size_gb >= 32 && var.os_disk_size_gb <= 1024
    error_message = "os_disk_size_gb must be between 32 and 1024."
  }
}

variable "kali_sku" {
  type        = string
  description = "Kali Linux image SKU. Verify with: az vm image list --publisher kali-linux --offer kali --all -o table"
  default     = "kali-2026-2"
}

variable "admin_username" {
  type        = string
  description = "Local admin account on the Kali VM."
  default     = "kali"
  validation {
    condition     = !contains(["admin", "administrator", "root"], lower(var.admin_username))
    error_message = "Azure reserves 'admin', 'administrator', and 'root' as VM usernames."
  }
}

variable "ssh_public_key" {
  type        = string
  description = "Contents of your SSH PUBLIC key (the ssh-ed25519 AAAA... string). Used for Bastion SSH."
  validation {
    condition     = can(regex("^(ssh-rsa|ssh-ed25519|ecdsa-sha2-) ", var.ssh_public_key))
    error_message = "ssh_public_key must be an OpenSSH public key string (starts with ssh-rsa, ssh-ed25519, or ecdsa-sha2-). If you pasted a PRIVATE key, stop and regenerate — you just leaked it."
  }
}

# 4. BROWSER BOOKMARKS
variable "aggregator_bookmarks" {
  type = list(object({
    title     = string
    url       = string
    folder    = optional(string, "CTI Feeds")
    placement = optional(string, "toolbar")
  }))
  description = "Clearnet CTI aggregators. Loaded into BOTH Firefox and Tor Browser."

  default = [
    {
      title = "RansomLook - browse groups"
      url   = "https://www.ransomlook.io/browse"
    },
    {
      title = "RansomLook - recent posts"
      url   = "https://www.ransomlook.io/recent"
    },
    {
      title = "RansomLook - API docs"
      url   = "https://www.ransomlook.io/doc"
    },
    {
      title = "ransomware.live"
      url   = "https://www.ransomware.live/"
    },
    {
      title = "RansomLook source"
      url   = "https://github.com/RansomLook/RansomLook"
    },
  ]
}
variable "onion_bookmarks" {
  type = list(object({
    title     = string
    url       = string
    folder    = optional(string, "Leak Sites")
    placement = optional(string, "toolbar")
  }))

  description = "Onion-only bookmarks. Tor Browser exclusively because Firefox has no circuit to resolve them."
  default     = []
}
# 5. TAGS
variable "tags" {
  type        = map(string)
  description = "Tags applied to every resource."

  default = {
    project     = "RansomWhere"
    environment = "lab"
    managed_by  = "terraform"
    ephemeral   = "true"
  }
}