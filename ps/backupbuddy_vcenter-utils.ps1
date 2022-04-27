# loading configuration stored in json form
$TestConfig = Get-Content "C:\Users\meckh\Documents\GitHub\ChamplainCapstone\ps\config.json" | ConvertFrom-Json
$rocksFolder = $TestConfig.rocksFolder

# Function responsible for connecting to the vcenter

Import-Module .\credentialtest.ps1 -Force
function Get-ScissorUser(){
    $VsphereUser= get-scissors
    return $VsphereUser
}
Function connect_server(){
    Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
    $user = Get-ScissorUser
    $default = $TestConfig.vCenterName
    Connect-VIServer -Server $default -Credential $user -ErrorAction Stop


}

Function select_vm(){

        $vmName = Read-Host "Enter the VM Name you wish to clone: "
        $vm=Get-VM -Name $vmName -ErrorAction Stop
        return $vm

}

Function pick_snapshot(){
    [CmdletBinding()]
    param (
        $vm
    )
    Write-Host $vm
    $date = Get-Date -Format "yyyyMMdd"
    $snapName = "{0}_backup" -f $date
    $snapshot = New-Snapshot -VM $vm -Name $snapName
    return $snapshot
}

function cloner () {
    
    connect_server
    $targets = $TestConfig.targets
# IN THEORY, This works by creating a new snapshot to backup off of on the target vm, and then deploys a linked clone based off of the
# reference snapshot and then exports the linked VM to an OVA template, for every target given by config.json
    foreach($target in $targets) {

        $snapshot = pick_snapshot -vm $vm

        $newname = "{0}.clone" -f $vm.Name

        #Testing to see if this works with full cloning
        #Linked Clone Option
        #$newvm = New-VM -Name $newname -VM $vm -LinkedClone -ReferenceSnapshot $snapshot -VMHost $TestConfig.vCenterName

        #Full Clone Option
        $newvm = New-VM -Name $newname -VM $vm -VMHost $vm.VMHost
        Get-VM -Name $newname | Export-VApp -Destination $rocksFolder -Format OVA
    }




}

cloner