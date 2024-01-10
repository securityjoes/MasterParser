# Start Time
$AuthLogStartTime = Get-Date

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
. "$RunningPath\02-LogModules\Auth.Log\03-Features\04-SSHTable.ps1"

# Dot Sourcing -> 05-UsersGroupsActivity.ps1
. "$RunningPath\02-LogModules\Auth.Log\03-Features\05-UsersGroupsActivity.ps1"

# Dot Sourcing -> 06-GeneralActivity.ps1
. "$RunningPath\02-LogModules\Auth.Log\03-Features\06-GeneralActivity.ps1"

if ($NotFoundHashTable.Values.Count -ge 1) {
# Element That Does Not Exist in This auth.log File
Write-Output ""
Write-Output "Element That Does Not Exist in This auth.log File"
Write-Output "+-----------------------------------------------+"
$NotFoundHashTable.Values
Write-Output ""
Write-Output ""
Write-Output " - End of '$Log' Report -"
Write-Output ""
Write-Output ""
}

# delete the auth.log copty after using it.
Start-Sleep -Seconds 1
Remove-Item -Path $AuthLogCopyLocation

# if the log file was extracted from a GZip file, remove it.
if ($WasExtracted -eq "true") {
Remove-Item -Path "$RunningPath\01-Logs\$Log"
}

# End Time
$AuthLogEndTime = Get-Date

$AuthLogTime = $AuthLogEndTime - $AuthLogStartTime

$AuthLogTimeInSeconds = $AuthLogTime.TotalSeconds.ToString("F3")