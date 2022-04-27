#Get General Utils
$generalutils_path = Get-ChildItem -Path C:\Users\$env:UserName -Filter backupbuddy_generalutils.ps1 -Recurse | %{$_.FullName}
Import-Module $generalutils_path


#Allows the user to enter Directory names for backup
$configpath = ResolveFilePath -File backupbuddy_config.json
$looper=1
$BigObject = Get-Content $configpath | ConvertFrom-Json
$targets = $BigObject.dirTargets


while($looper -eq 1){
    $entry = Read-Host -Prompt "Please enter the full file path of the directory you wish to back up, or leave entry blank to exit."
    if($entry -and $targets.Contains($entry)){ 
        Write-Output "Named Directory already exists as a target."
    }elseif($entry -and !($targets.Contains($entry))){
        $entry -replace "\$", "\\"
        $targets += $entry


    }else{
        $looper=0
    }
}
$BigObject.dirTargets = $targets
$BigObject | Convertto-Json -Depth 100 | Out-File $configpath