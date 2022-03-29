# loading configuration stored in json form
$TestConfig = Get-Content "config.json" | ConvertFrom-Json
$rocksFolder = $TestConfig.rocksFolder

# Function responsible for connecting to the vcenter
Import-Module .\credentialtest.ps1 -Force
function Get-ScissorUser(){
    $VsphereUser= get-scissors
    return $VsphereUser
}
Function connect_server(){
    $user = Get-ScissorUser
    $default = $TestConfig.vCenterName
    Try
    {
        Connect-VIServer($default) -Credential $user  -ErrorAction Stop

    }Catch{
        Write-Output "!!!Error!!! - Could not connect to vCenter. Check your vCenter server name and your vCenter credentials."
        
    }
}

Function select_vm(){
    Try{
        $vmName = Read-Host "Enter the VM Name you wish to clone: "
        $vm=Get-VM -Name $vmName -ErrorAction Stop
        return $vm

    }Catch{
        Write-Output "!!!Error!!! - Enter an existing VM name"
        exit
    }
}

Function pick_snapshot(){
    [CmdletBinding()]
    param (
        $vm
    )
    Try{
        $date = Get-Date -Format "yyyy_dd_MM"
        $snapName = "{0}_backup" -f $date
        $snapshot = New-Snapshot -VM $vm -Name $snapName
        return $snapshot
    }Catch{
        Write-Output "!!!Error!!! - Unable to Creat Snapshot!"
        exit
}
}

function cloner () {
    
    connect_server
    $targets = $TestConfig.targets
# IN THEORY, This works by creating a new snapshot to backup off of on the target vm, and then deploys a linked clone based off of the
# reference snapshot and then exports the linked VM to an OVA template, for every target given by config.json
    foreach($target in $targets) {
        $snapshot = pick_snapshot -vm $vm
        $vm=Get-VM -Name $target -ErrorAction Stop
        $newname = "{0}.linked" -f $vm.Name
        $newvm = New-VM -Name $newname -VM $vm -LinkedClone -ReferenceSnapshot $snapshot
        Get-VM -Name $newname | Export-VApp -Destination $rocksFolder -Format OVA
    }




}

cloner