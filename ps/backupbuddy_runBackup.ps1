#Get General Utils
$generalutils_path = Get-ChildItem -Path C:\Users\$env:UserName -Filter backupbuddy_generalutils.ps1 -Recurse | %{$_.FullName}
Import-Module $generalutils_path



$vcenterutilspath = ResolveFilePath -File backupbuddy_vcenter-utils.ps1
$directoryutilspath = ResolveFilePath -File backupbuddy_directoryutils.ps1


& "$vcenterutilspath"
& "$directoryutilspath"