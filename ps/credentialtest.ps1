
# This method of storing credentials is specific to the machine and the user.
$credential = Get-Credential
$credential | Export-CliXml -Path 'cred.xml'


$credential = Import-CliXml -Path 'cred.xml'
