#Allows the user to enter VM names for backup
$looper=1

while($looper -eq 1){
    $entry = Read-Host -Prompt "Please enter the Name of the Virtual Machine you wish to back up, or leave entry blank to exit."
    if($entry){
        $entry >> VMlist.txt
    }else{
        $looper=0
    }

}