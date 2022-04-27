#Allows the user to delete directory names from backup
$looper=1
$BigObject = Get-Content "C:\Users\meckh\Documents\GitHub\ChamplainCapstone\ps\config.json" | ConvertFrom-Json
$targets = $BigObject.dirTargets
Write-Output $targets

while($looper -eq 1){
    $entry = Read-Host -Prompt "Please enter the Name of the Directory you wish to remove from Inventory, or leave entry blank to exit"


    if($entry -and $targets.Contains($entry)){ 

        $choice = Read-Host -Prompt "Are you sure you wish to delete this Directory from Inventory?[y/N]"
		if(($choice -eq "y") -or ($choice -eq "Y")){
		    $targets = $targets | Where-Object {$_ -ne $entry}
            Write-Output "Entry Deleted."
        }elseif(($choice -eq "n") -or ($choice -eq "N")){
            Write-Output "Cancelled"
        }else{
            Write-Output "Bad Input, Please enter 'y/Y' or 'n/N'."
        }

    }elseif($entry -and ($targets -eq $null)){
        Write-Output "ERROR, Directory List is Empty - Please use 'Add Directories' to set directories up for backup."
        $looper=1

    }elseif($entry -and !($targets.Contains($entry))){
        Write-Output "Entered name does not exist in the entry."

    }else{
        $looper=0
    }


	
}
$BigObject.dirTargets = $targets
$BigObject | Convertto-Json -Depth 100 | Out-File "C:\Users\meckh\Documents\GitHub\ChamplainCapstone\ps\config.json"