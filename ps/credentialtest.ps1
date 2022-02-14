# a series of functions designed to grab and deploy credentials
function credential-manager {
# By default, the path to the credential file is stored here. The function is designed such that a user will be able to tell the program where to look for
# or where to store the credential file.
  $testpath = "path\To\stored-creds"
  if (!$args[0]) {
    continue
  }else{
    $testpath = $args[0]
  }



# This method of storing credentials is specific to the machine and the user.
  if (-not (Test-Path -Path $testpath -PathType Leaf)){
    Write-Host "Credential file not found - creating new credentials..."
    $credential = Get-Credential
    $credential | Export-CliXml -Path $testpath
  }else{
    Write-Host "Retrieving Credentials
    $credential = Import-CliXml -Path $testpath
  }
  return $credential
}
