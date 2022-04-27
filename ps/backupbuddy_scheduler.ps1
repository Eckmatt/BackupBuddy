#Scheduler
#Get General Utils
$generalutils_path = Get-ChildItem -Path C:\Users\$env:UserName -Filter backupbuddy_generalutils.ps1 -Recurse | %{$_.FullName}
Import-Module $generalutils_path



# This module builds a Scheduled Task
$runpath = ResolveFilePath -File backupbuddy_runBackup.ps1

$action = New-ScheduledTaskAction -Execute $runpath
$trigger = ""
$choice = Read-Host -Prompt "How Often would you like to run a Backup? `r`n[1]Weekly`r`n[2]Bi-Weekly`r`n[3]Monthly`r`n"

switch ($choice)
{

    1 {$trigger = New-ScheduledTaskTrigger -Weekly -WeeksInterval 1 -DaysOfWeek Friday -At 5pm}
    2 {$trigger = New-ScheduledTaskTrigger -Weekly -WeeksInterval 2 -DaysOfWeek Friday -At 5pm}
    3 {$trigger = New-ScheduledTaskTrigger -Weekly -WeeksInterval 4 -DaysOfWeek Friday -At 5pm}

}

$principal = New-ScheduledTaskPrincipal -UserId $env:UserName
$settings = New-ScheduledTaskSettingsSet -RunOnlyIfNetworkAvailable -WakeToRun
$task = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger -Settings $settings

Register-ScheduledTask 'Backup Buddy Automated Backup' -InputObject $task