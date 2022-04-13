#Allows the user to enter Directory names for backup
$looper=1
$BigObject = Get-Content "C:\Users\meckh\Documents\GitHub\ChamplainCapstone\ps\config.json" | ConvertFrom-Json
$targets = $BigObject.dirTargets


while($looper -eq 1){
    $entry = Read-Host -Prompt "Please enter the full file path of the directory you wish to back up, or leave entry blank to exit."
    if($entry -and $targets.Contains($entry)){ 
        Write-Output "Named Directory already exists as a target."
    }elseif($entry -and !($targets.Contains($entry))){
        $entry -replace "\$", "\\"
        Write-Output $entry
        $targets += $entry


    }else{
        $looper=0
    }
}
$BigObject.dirTargets = $targets
$BigObject | Convertto-Json -Depth 100 | Out-File "C:\Users\meckh\Documents\GitHub\ChamplainCapstone\ps\config.json"