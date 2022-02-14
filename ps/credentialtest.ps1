$testpath = "c:\Users\me\path\To\stored-creds"
# This method of storing credentials is specific to the machine and the user.
if (Test-Path -Path $testpath -PathType Leaf){

  $credential = Get-Credential
  $credential | Export-CliXml -Path 'cred.xml'
}else{
  $credential = Import-CliXml -Path 'cred.xml'
}
