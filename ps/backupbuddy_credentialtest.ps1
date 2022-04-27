# a series of functions designed to grab and deploy credentials

# grabs general utils
$generalutils_path = Get-ChildItem -Path C:\Users\$env:UserName -Filter backupbuddy_generalutils.ps1 -Recurse | %{$_.FullName}
Import-Module $generalutils_path


function get-scissors() {
# By default, the path to the credential file is stored here. The function is designed such that a user will be able to tell the program where to look for
# or where to store the credential file.
  $configpath = ResolveFilePath -File backupbuddy_config.json
  $TestConfig = Get-Content $configpath | ConvertFrom-Json
  $testpath = $TestConfig.scissorPath



# This method of storing credentials is specific to the machine and the user.
  if (-not (Test-Path -Path $testpath -PathType Leaf)){
    Write-Host "!!! Credential file not found - creating new credentials... !!!"
    $credential = Get-Credential
    $credential | Export-CliXml -Path $testpath
  }else{
    Write-Host "!!! Retrieving Credentials !!!"
    $credential = Import-CliXml -Path $testpath
  }
  return $credential
}

