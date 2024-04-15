To install Packer on Ubuntu Linux, you can follow these steps:

1. **Download Packer**:
   First, you need to download the Packer binary. You can do this using `wget` or `curl`. Make sure to check the [official Packer website](https://www.packer.io/downloads) for the latest version. For example:

   ```bash
   wget https://releases.hashicorp.com/packer/<version>/packer_<version>_linux_amd64.zip
   ```

   Replace `<version>` with the version number you want to install. For example:

   ```bash
   wget https://releases.hashicorp.com/packer/1.7.4/packer_1.7.4_linux_amd64.zip
   ```

2. **Extract the Archive**:
   Once the download is complete, unzip the downloaded file:

   ```bash
   unzip packer_1.7.4_linux_amd64.zip
   ```

3. **Move Packer Binary**:
   Move the Packer binary to a directory in your system's PATH. `/usr/local/bin` is a common choice:

   ```bash
   sudo mv packer /usr/local/bin
   ```

4. **Verify Installation**:
   To ensure that Packer has been installed correctly, you can run:

   ```bash
   packer --version
   ```

   This command should return the installed Packer version, confirming that it's successfully installed.

That's it! You've now installed Packer on your Ubuntu Linux system. You can now use Packer to create machine images for various platforms.

https://github.com/srakesh28/azuredevops-terraform-ansible-packer-sig


client_id       = 2fb2d12f-0c4e-4bea-83ca-221a9a30b6f8
client_secret   = wwJ8Q~HFyshUBFdXrsaZLg-SP.8CS.v3slGWxcVJ
subscription_id = c39f4598-3052-44c2-9661-3adc94a74db7
tenant_id       = 32bfbe7c-7026-46ca-af3b-612d1a80d41f

az group create --name packer --location centralindia
az network vnet create --resource-group packer --name packvnet --subnet-name packersub
az network nsg create --resource-group packer --name packernsg
az storage account create --name packerstore --resource-group packer --location centralindia --sku Standard_LRS
az storage container create --name packerstorec --account-name packerstore --public-access blob

az storage container create --name packerstorec --account-name packerstore --public-access blob --connection-string "<your_connection_string>"

az ad sp create-for-rbac --role Contributor --name sp-packer-001

az ad sp create-for-rbac --name myServicePrincipalName1 --role contributor --scopes /subscriptions/c39f4598-3052-44c2-9661-3adc94a74db7/resourceGroups/packer


# Bash script

vboxuser@Ubuntu-Linux:~$ az ad sp create-for-rbac --name myServicePrincipalName1 --role contributor --scopes /subscriptions/c39f4598-3052-44c2-9661-3adc94a74db7/resourceGroups/packerimages
Creating 'contributor' role assignment under scope '/subscriptions/c39f4598-3052-44c2-9661-3adc94a74db7/resourceGroups/packer'
The output includes credentials that you must protect. Be sure that you do not include these credentials in your code or check the credentials into your source control. For more information, see https://aka.ms/azadsp-cli
{
  "appId": "b2e16500-2c4a-44b6-a65c-8f0864c1b6ee",
  "displayName": "myServicePrincipalName1",
  "password": "lZI8Q~K8CWgJdAg3k6Yn6HpIcnt9n1eGnuYSccEn",
  "tenant": "32bfbe7c-7026-46ca-af3b-612d1a80d41f"
}

vboxuser@Ubuntu-Linux:~$ az ad sp create-for-rbac --name myServicePrincipalName1 --role contributor --scopes /subscriptions/c39f4598-3052-44c2-9661-3adc94a74db7/resourceGroups/packerimages
Found an existing application instance: (id) b1ea630e-fef7-423e-86d9-92b4dde357e2. We will patch it.
Creating 'contributor' role assignment under scope '/subscriptions/c39f4598-3052-44c2-9661-3adc94a74db7/resourceGroups/packerimages'
The output includes credentials that you must protect. Be sure that you do not include these credentials in your code or check the credentials into your source control. For more information, see https://aka.ms/azadsp-cli
{
  "appId": "b2e16500-2c4a-44b6-a65c-8f0864c1b6ee",
  "displayName": "myServicePrincipalName1",
  "password": "j2g8Q~iuP7Oay1XLnCR4HajtzZ1IsnKz70snBbwh",
  "tenant": "32bfbe7c-7026-46ca-af3b-612d1a80d41f"
}

az vm list-skus --location centralindia --size Standard_A --output table 

vboxuser@Ubuntu-Linux:~$ az vm list-skus --location centralindia --size Standard_A --output table 
ResourceType     Locations     Name             Zones    Restrictions
---------------  ------------  ---------------  -------  --------------
virtualMachines  CentralIndia  Standard_A1_v2   1,2,3    None
virtualMachines  CentralIndia  Standard_A2m_v2  1,2,3    None
virtualMachines  CentralIndia  Standard_A2_v2   1,2,3    None
virtualMachines  CentralIndia  Standard_A4m_v2  1,2,3    None
virtualMachines  CentralIndia  Standard_A4_v2   1,2,3    None
virtualMachines  CentralIndia  Standard_A8m_v2  1,2,3    None
virtualMachines  CentralIndia  Standard_A8_v2   1,2,3    None



az group create -l centralindia -n packerimages