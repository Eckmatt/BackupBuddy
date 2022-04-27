# Directory Utils
function directBackup () {
    $BigObject = Get-Content "C:\Users\meckh\OneDrive\Documents\GitHub\ChamplainCapstone\ps\config.json" | ConvertFrom-Json
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