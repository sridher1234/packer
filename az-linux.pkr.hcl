packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "azure-arm" "ubuntu" {
  use_azure_cli_auth                = "true"
  client_id                         = "b2e16500-2c4a-44b6-a65c-8f0864c1b6ee"
  client_secret                     = "nNa8Q~ld4ltZ9eMDfm2wWmh.zS3f71ajBK48tcw1"
  managed_image_resource_group_name = "packerimages" # You must create a resource group to save the images to
  managed_image_name                = "packer-ubuntu-azure-{{timestamp}}"
  subscription_id                   = "c39f4598-3052-44c2-9661-3adc94a74db7"
  tenant_id                         = "32bfbe7c-7026-46ca-af3b-612d1a80d41f"
  
  os_type         = "Linux"
  image_publisher = "Canonical"
  image_offer     = "0001-com-ubuntu-server-jammy"
  image_sku       = "22_04-lts"

  azure_tags = {
    Created-by = "VenkatramanB"
    OS_Version = "Ubuntu 22.04"
    Release    = "Latest"
  }

  location = "centralindia"
  vm_size  = "Standard_A2_v2"
}

build {
  name = "ubuntu"
  sources = [
    "source.azure-arm.ubuntu",
  ]

 
  provisioner "shell" {
    inline = [
      "echo 'shell started'",
      "sudo su -",
      "whoami",
      "echo 'Packer is the username'",
      "sudo apt-get update"
   ]
  }

  provisioner "ansible" {
    playbook_file = "./playbook.yaml"
    ansible_env_vars = [
      "ANSIBLE_SSH_ARGS='-o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=ssh-rsa'",
      "ANSIBLE_HOST_KEY_CHECKING=False"
    ]
  }


  post-processor "manifest" {}

}
