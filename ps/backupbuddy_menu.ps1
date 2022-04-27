#This menu script creates a powershell menu, that will allow the user to interact with the script, and perform data entry for the rest of the script

#Get General Utils
$generalutils_path = Get-ChildItem -Path C:\Users\$env:UserName -Filter backupbuddy_generalutils.ps1 -Recurse | %{$_.FullName}
Import-Module $generalutils_path


# Check to make sure necessary modules are installed

# Check to see if PSScriptMenuGui is installed
$guiInstall = Get-Module -ListAvailable -Name PSScriptMenuGui
if($guiInstall -eq $null){
    $looper = 0
    while($looper -eq 0){
        $choice = Read-Host -Prompt "Missing Necessary Module - PSScriptMenuGui. Would you like to download now?[y/N]"
        if(($choice -eq "y") -or ($choice -eq "Y")){
            Install-Module -Name PSScriptMenuGui -AllowClobber -Force
            $looper=1
        }elseif(($choice -eq "n") -or ($choice -eq "N")){
            Write-Host "PSScriptMenuGui Install Cancelled, terminating..."
            exit 0
        }else{
            Write-Host "Please Enter [y/N]"
        }
    }
}
#Import Menu Gui
Import-Module PSScriptMenuGui
try{
    $powerCLIInstall = Get-Package -Name "VMware PowerCLI"
}catch [NoMatchFound]{
    Read-Host -Prompt "VMware PowerCLI was not found. PowerCLI is required to interface with vSphere and perform backups. Would you like to download it now? [y/N]"
    $looper = 0
    while($looper -eq 0){
        $choice = Read-Host -Prompt "Missing Necessary Module - PSScriptMenuGui. Would you like to download now?[y/N]"
        if(($choice -eq "y") -or ($choice -eq "Y")){
            Install-Module -Name VMware.PowerCLI -Scope CurrentUser -AllowClobber -Force
            $looper=1
        }elseif(($choice -eq "n") -or ($choice -eq "N")){
            Write-Host "VMware PowerCLI is not Installed, certain functionality will not work!"
            $looper=1
        }else{
            Write-Host "Please Enter [y/N]"
        }
    }    

} 

#Change to match file path
$menupath = ResolveFilePath -File backupbuddy_userinterface.csv
Show-ScriptMenuGui -csvPath $menupath -windowTitle "Backup Buddy"