#Get General Utils
$generalutils_path = Get-ChildItem -Path C:\Users\$env:UserName -Filter backupbuddy_generalutils.ps1 -Recurse | %{$_.FullName}
Import-Module $generalutils_path

# Directory Utils
function DirBackup () {
    $configpath = ResolveFilePath -File backupbuddy_config.json
    $BigObject = Get-Content $configpath | ConvertFrom-Json
    $targets = $BigObject.dirTargets
    $rocksFolder = $BigObject.rocksFolder
    $rocksFolder.Trim('"')


    foreach($target in $targets){
        $archiveName=$target.Replace("\","_")
        $archiveName+=".zip"
        $target+="\*"
        & "C:\Program Files\7-Zip\7z.exe" a -tzip $archiveName -o$rocksFolder $target
    }
}