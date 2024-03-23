# Start time
$RunningStartTime = Get-Date

# NotFoundHashTable
$NotFoundHashTable = @{}

# Dot Sourcing -> 01-TimePatch.ps1
. "$RunningPath\02-LogModules\Auth.Log\02-TimePatch\01-TimePatch.ps1"

# if statment to check if TimePatch is needed
if ($CreateLogCopy_Flag -eq "True") {
# Dot Sourcing -> CreateLogCopy.ps1
. "$RunningPath\02-LogModules\Auth.Log\01-LogCopy\CreateLogCopy.ps1"
}

# Dot Sourcing -> FileSummaryReport.ps1
. "$RunningPath\02-LogModules\Auth.Log\03-Features\01-FileSummaryReport.ps1"

# Dot Sourcing -> 02-EventNameTable.ps1
. "$RunningPath\02-LogModules\Auth.Log\03-Features\02-EventNameTable.ps1"

# Dot Sourcing -> 03-IPAddressTable.ps1
. "$RunningPath\02-LogModules\Auth.Log\03-Features\03-IPAddressTable.ps1"

# Dot Sourcing -> 04-SSHTable.ps1
. "$RunningPath\02-LogModules\Auth.Log\03-Features\04-SSH.ps1"

# Dot Sourcing -> 05-UsersGroupsActivity.ps1
. "$RunningPath\02-LogModules\Auth.Log\03-Features\05-UsersGroupsActivity.ps1"

# Dot Sourcing -> 06-GeneralActivity.ps1
. "$RunningPath\02-LogModules\Auth.Log\03-Features\06-GeneralActivity.ps1"

# Dot Sourcing -> 07-sudoActivity.ps1
. "$RunningPath\02-LogModules\Auth.Log\03-Features\07-sudoActivity.ps1"

# Dot Sourcing -> 08-FTPActivity.ps1
. "$RunningPath\02-LogModules\Auth.Log\03-Features\08-FTP.ps1"

Write-Output ""
Write-Output ""
Write-Output " - End of '$Log' Report -"
Write-Output ""
Write-Output ""

# delete the auth.log copty after using it.
Remove-Item -Path $AuthLogCopyLocation

# if the log file was extracted from a GZip file, remove it.
if ($WasExtracted -eq "true") {
    Remove-Item -Path "$RunningPath\01-Logs\$Log"
}

# End Time
$RunningEndTime = Get-Date
$RunningTime = ($RunningEndTime - $RunningStartTime).TotalSeconds

# Calc if running was in seconds, minutes, or hours
if ($RunningTime -le 60) {
    $RunningTime = "{0:00}:{1:00}" -f 0, $RunningTime
    $RunningTime = Write-Output "$RunningTime Seconds"
}
elseif ($RunningTime -le 3600) {
    $Minutes = [math]::Floor($RunningTime / 60)
    $Seconds = $RunningTime % 60
    $RunningTime = "{0:00}:{1:00}" -f $Minutes, $Seconds
    $RunningTime = Write-Output "$RunningTime Minutes"
}
else {
    $Hours = [math]::Floor($RunningTime / 3600)
    $Minutes = [math]::Floor(($RunningTime % 3600) / 60)
    $Seconds = $RunningTime % 60
    $RunningTime = "{0:00}:{1:00}:{2:00}" -f $Hours, $Minutes, $Seconds
    $RunningTime = Write-Output "$RunningTime Hours"
}

