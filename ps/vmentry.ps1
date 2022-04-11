#Allows the user to enter VM names for backup
$looper=1
$BigObject = Get-Content "C:\Users\meckh\Documents\GitHub\ChamplainCapstone\ps\config.json" | ConvertFrom-Json
$targets = $BigObject.targets


while($looper -eq 1){
    $entry = Read-Host -Prompt "Please enter the Full Name of the Virtual Machine you wish to back up, or leave entry blank to exit."
    if($entry -and $targets.Contains($entry)){ 
        $targets += $entry
    }elif($entry -and !($targets.Contains($entry)){
        Read-Host
    }else{
        $looper=0
    }fi
}
$targets 