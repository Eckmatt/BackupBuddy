# test config for default configuration
# $TestConfig = Get-Content "~/path/to/test/config" | ConvertFrom-Json

# Function responsible for connecting to the vcenter
function load-user(){

}
Function connect_server(){
    $default = $TestConfig.vCenterName
    Try
    {
        $vserver= Read-Host "Please enter the FQDN or IP address of your Vcenter server [$default]: "
        if ([string]::IsNullOrWhiteSpace($vserver))
        {
            Connect-VIServer($default) -User  -ErrorAction Stop
        }else{
            Connect-VIServer($vserver) -User riku -ErrorAction Stop
        }
        

    }Catch{
        Write-Output "!!!Error!!! - Could not connect to vCenter. Check your Vcenter server name and your Vcenter credentials."
        
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
        $snapName = Read-Host "Enter the Name of "$vm.Name"'s Snapshot you wish to clone" 
        $snapshot=Get-Snapshot -VM $vm -Name $snapName -ErrorAction Stop
        return $snapshot
    }Catch{
        Write-Output "!!!Error!!! - Snapshot not found!"
        exit
}
}

Function pick_hostname(){
    $default = $defaultConfig.hostname
    Try{

        $hostname = Read-Host "Enter the Name of the esxi host you wish to store your clone [$default]"
        if ([string]::IsNullOrWhiteSpace($hostname))
        {
            $vmhost = Get-VMHost -Name $default -ErrorAction Stop
        }else{
            $vmhost = Get-VMHost -Name $hostname -ErrorAction Stop
        }
        
        return $vmhost

    }Catch{
        Write-Warning $Error[0]
        exit
    }

}

function power_on(){

    param(
        $vm
    )
    Start-VM -VM $vm -Confirm -RunAsync

}

function cloner () {
    
    connect_server
    $vm = select_vm
    $snapshot = pick_snapshot -vm $vm
    $vmhost = pick_hostname
    $dstore = pick_datastore
    $folder = pick_folder

    $choice = Read-Host "Create a Linked Clone or Full Clone? Enter [L/l] for Linked Clone or [F/f] for Full Clone"
    If($choice -eq 'F' -or $choice -eq 'f' )
    {
        $Tempname = "{0}.temp" -f $vm.Name
        $Tempvm = New-VM -Name $Tempname -VM $vm -LinkedClone -ReferenceSnapshot $snapshot -VMHost $vmhost -Datastore $dstore
        $newname = Read-Host "Enter a name for your New VM"

        $newvm = New-VM -Name $newname -VM $Tempvm -VMHost $vmhost -Datastore $dstore -Location $folder
        setNetwork -vm $newvm
        $newvm | new-snapshot -Name "Base"
        $Tempvm | Remove-VM

    }elseif ($choice -eq 'L' -or $choice -eq 'l' ) {
        $newname = "{0}.linked" -f $vm.Name
        $newvm = New-VM -Name $newname -VM $vm -LinkedClone -ReferenceSnapshot $snapshot -VMHost $vmhost -Datastore $dstore -Location $folder
        setNetwork -vm $newvm

    }else{
        throw "Select Either [L]inked Clone or [F]ull Clone"
    }

}
