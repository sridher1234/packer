packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }
  }
}

variable "azure_subscription_id" {
  type        = string
  description = "Azure subscription ID"
  default     = "c39f4598-3052-44c2-9661-3adc94a74db7"
}

variable "azure_tenant_id" {
  type        = string
  description = "Azure tenant ID"
  default     = "32bfbe7c-7026-46ca-af3b-612d1a80d41f"
}

variable "azure_client_id" {
  type        = string
  description = "Azure client ID"
  default     = "b2e16500-2c4a-44b6-a65c-8f0864c1b6ee"
}

variable "azure_client_secret" {
  type        = string
  description = "Azure client secret"
  default     = "j2g8Q~iuP7Oay1XLnCR4HajtzZ1IsnKz70snBbwh"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "azure-arm" "windows_2022" {
  use_azure_cli_auth = "true"
  subscription_id    = var.azure_subscription_id
  tenant_id          = var.azure_tenant_id
  client_id          = var.azure_client_id
  client_secret      = var.azure_client_secret

  managed_image_name                = "packer-w2k22-azure-${local.timestamp}"
  managed_image_resource_group_name = "packernimages"

  os_type         = "Windows"
  image_publisher = "microsoftwindowsserver"
  image_offer     = "windowsserver"
  image_sku       = "2022-datacenter-azure-edition-hotpatch"

  communicator     = "winrm"
  winrm_use_ssl    = true
  winrm_insecure   = true
  winrm_timeout    = "5m"
  winrm_username   = "packer"
  custom_data_file = "./scripts/SetUpWinRM.ps1"

  azure_tags = {
    Created-by = "VenkatramanB"
    OS_Version = "Windows 2022"
    Release    = "Latest"
  }

  location = "eastus"
  vm_size  = "Standard_D2s_v3"
}

build {
  name    = "windows"
  sources = ["source.azure-arm.windows_2022"]

  provisioner "ansible" {
    playbook_file = "./win_playbook.yml"
    user          = "packer"
    use_proxy     = false
    extra_arguments = [
      "--connection", "winrm", "-vvv",
      "-e", "ansible_winrm_transport=ntlm ansible_winrm_server_cert_validation=ignore ansible_shell_type=powershell"
    ]
  }

  provisioner "powershell" {
    inline = [
      "Add-WindowsFeature Web-Server",
      "while ((Get-Service RdAgent).Status -ne 'Running') { Start-Sleep -s 5 }",
      "while ((Get-Service WindowsAzureGuestAgent).Status -ne 'Running') { Start-Sleep -s 5 }",
      "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit",
      "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { break } }"
    ]
  }

  post-processor "manifest" {}
}