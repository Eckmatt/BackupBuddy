#Allows the user to enter directory names for backup
$looper=1

while($looper -eq 1){
    $entry = Read-Host -Prompt "Please enter the full filepath of the directory you wish to back up, or leave entry blank to exit."
    if($entry){
        $entry >> directorylist.txt
    }else{
        $looper=0
    }

}