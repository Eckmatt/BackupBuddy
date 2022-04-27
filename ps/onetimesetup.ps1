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

#Prompts the User to enter config info
$UserConfig.vCenterName = Read-Host -Prompt "Please Enter the Name(FQDN) or the IP Address of your vSphere machine, or leave blank to skip"

$UserConfig.rocksFolder = Read-Host -Prompt "Please Enter the full filepath of the directory to store backups"

$UserConfig.scissorPath = Read-Host -Prompt "Please Enter the full filepath of the directory to store credentials (Credentials are stored with full encryption)"

#Obtains config path and correctly saves filepath regardless of location on disk.
$configpath = Get-ChildItem -Path C:\Users\$env:UserName -Filter config.json -Recurse | %{$_.FullName}
$UserConfig | Convertto-Json -Depth 100 | Out-File $configpath

#Prompts the User to input VM and directory targets

$looper = 0
 while($looper -eq 0){
    
    $choice = Read-Host -Prompt "Would you like to input Virtual Machine's to backup?[y/N]"
    if(($choice -eq "y") -or ($choice -eq "Y")){
        & "vmentry.ps1"
        $looper=1
    }elseif(($choice -eq "n") -or ($choice -eq "N")){
        Write-Host "VM Entry Cancelled. VM's can be added later using the 'VM Entry' function on the main menu."
        $looper=1
    }else{
        Write-Host "Please Enter [y/N]"
    }
}


$looper = 0
 while($looper -eq 0){
    
    $choice = Read-Host -Prompt "Would you like to input Virtual Machine's to backup?[y/N]"
    if(($choice -eq "y") -or ($choice -eq "Y")){
        & "vmentry.ps1"
        $looper=1
    }elseif(($choice -eq "n") -or ($choice -eq "N")){
        Write-Host "VM Entry Cancelled. VM's can be added later using the 'VM Entry' function on the main menu."
        $looper=1
    }else{
        Write-Host "Please Enter [y/N]"
    }
}