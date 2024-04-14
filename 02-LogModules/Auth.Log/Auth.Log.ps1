$auth_log_start_time = start_time

# NotFoundHashTable
$NotFoundHashTable = @{}

# Dot Sourcing -> 01-TimePatch.ps1
. "$RunningPath\02-LogModules\Auth.Log\02-TimePatch\01-TimePatch.ps1"

# if statment to check if TimePatch is needed
if ($CreateLogCopy_Flag -eq "True") {
# Dot Sourcing -> CreateLogCopy.ps1
. "$RunningPath\02-LogModules\Auth.Log\01-LogCopy\CreateLogCopy.ps1"
}

# Dot Sourcing -> 01-file_summary_report.ps1
. "$RunningPath\02-LogModules\Auth.Log\03-Features\01-file_summary_report.ps1"

# Dot Sourcing -> 02-event_name_table.ps1
. "$RunningPath\02-LogModules\Auth.Log\03-Features\02-event_name_table.ps1"

# Dot Sourcing -> 03-ip_address_table.ps1
. "$RunningPath\02-LogModules\Auth.Log\03-Features\03-ip_address_table.ps1"

# Dot Sourcing -> 04-regex_search_engine.ps1
. "$RunningPath\02-LogModules\Auth.Log\03-Features\04-regex_search_engine.ps1"

# Dot Sourcing -> 05-system_login_calculation.ps1
. "$RunningPath\02-LogModules\Auth.Log\03-Features\05-system_login_calculation.ps1"

# Dot Sourcing -> 06-ssh_login_calculation.ps1
. "$RunningPath\02-LogModules\Auth.Log\03-Features\06-ssh_login_calculation.ps1"

# Dot Sourcing -> 09-final_output.ps1
. "$RunningPath\02-LogModules\Auth.Log\03-Features\09-final_output.ps1"

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

$auth_log_run_time = stop_time -start_time $auth_log_start_time