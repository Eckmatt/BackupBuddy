# Setup Config Script
# Configures the following settings: vCenterName, rocksFolder, vmTargets, dirTargets, scissorPath, and allows scheduling of automated backup


$UserConfig = [PSCustomObject]@{
    vCenterName = ""
    rocksFolder = ""
    vmTargets = @()
    dirTargets = @()
    scissorPath = ""
}

Write-Host "Welcome to the Backup Buddy"

$UserConfig.vCenterName = Read-Host -Prompt "Please Enter the Name(FQDN) or the IP Address of your vSphere machine"

$UserConfig.rocksFolder = Read-Host -Prompt "Please Enter the full filepath of the directory to store backups"

$UserConfig.scissorPath = Read-Host -Prompt "Please Enter the full filepath of the directory to store credentials (Credentials are stored with full encryption)"