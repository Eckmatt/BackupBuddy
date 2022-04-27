#Get General Utils
$generalutils_path = Get-ChildItem -Path C:\Users\$env:UserName -Filter backupbuddy_generalutils.ps1 -Recurse | %{$_.FullName}
Import-Module $generalutils_path

#resolving config filepath
$configpath = ResolveFilePath -File backupbuddy_config.json

#Allows the user to delete VM names from backup
$looper=1
$BigObject = Get-Content $configpath | ConvertFrom-Json
$targets = $BigObject.vmTargets

while($looper -eq 1){
    $entry = Read-Host -Prompt "Please enter the Name of the Virtual Machine you wish to remove from Inventory, or leave entry blank to exit."

    if($entry -and $targets.Contains($entry)){ 

        $choice = Read-Host -Prompt "Are you sure you wish to delete this VM from Inventory?[y/N]"
		if(($choice -eq "y") -or ($choice -eq "Y")){
		    $targets = $targets | Where-Object {$_ -ne $entry}
            Write-Output "Entry Deleted."
        }elseif(($choice -eq "n") -or ($choice -eq "N")){
            Write-Output "Cancelled"
        }else{
            Write-Output "Bad Input, Please enter 'y/Y' or 'n/N'."
        }

    }elseif($entry -and ($targets -eq $null)){
        Write-Output "ERROR, VM List is Empty - Please use 'Add VMs' to set VMs up for backup."
        $looper=1

    }elseif($entry -and !($targets.Contains($entry))){
        Write-Output "Entered name does not exist in the entry."

    }else{
        $looper=0
    }


	
}
$BigObject.vmTargets = $targets
$BigObject | Convertto-Json -Depth 100 | Out-File $configpath