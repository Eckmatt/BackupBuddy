# Directory Utils

$BigObject = Get-Content "C:\Users\meckh\Documents\GitHub\ChamplainCapstone\ps\config.json" | ConvertFrom-Json
$targets = $BigObject.dirTargets
$rocksFolder = $BigObject.rocksFolder


foreach($target in $targets){
    Compress-Archive -Path $target -DestinationPath $rocksFolder
}