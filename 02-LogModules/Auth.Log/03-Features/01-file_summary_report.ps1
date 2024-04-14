# start time
if ($Mode -eq "Developer") {
$file_summary_report_start_time = start_time
}

# starting variables
#region

$auth_log_path =  "$RunningPath\02-LogModules\Auth.Log\01-LogCopy\Auth.Log.Parser.Copy.txt"

#endregion

# hostname
#region

$temp_line = Get-Content -Head 1 -Path $auth_log_path
$remove_start = $temp_line -replace '\b[a-zA-Z]{3}\s+\d{1,2}\s+\d{2}:\d{2}:\d{2}\b ',''
$hostname = $remove_start -replace ' .*',''
#endregion

# file size
#region

# Get the file size
$fileSize = (Get-Item $auth_log_path).Length

if ($fileSize -lt 1KB) {
    $log_size = "$fileSize bytes"
}
elseif ($fileSize -lt 1MB) {
    $fileSizeKB = [math]::Round($fileSize / 1KB, 2)
    $log_size = "$fileSizeKB KB"
}
elseif ($fileSize -lt 1GB) {
    $fileSizeMB = [math]::Round($fileSize / 1MB, 2)
    $log_size = "$fileSizeMB MB"
}
else {
    $fileSizeGB = [math]::Round($fileSize / 1GB, 2)
    $log_size = "$fileSizeGB GB"
}

#endregion

# start and end time
#region

$temp_line = Get-Content -Head 1 -Path $auth_log_path
$start_time = $temp_line -replace " $hostname.*",""
$start_time = $start_time -replace '  ',' '

$temp_line = Get-Content -Tail 1 -Path $auth_log_path
$end_time = $temp_line -replace " $hostname.*",""
$end_time = $end_time -replace '  ',' '

# execute duration function
$full_duration_file_summary_report = duration_calc -start_time $start_time -end_time $end_time
#endregion

# file summary report tamplate
#region

Write-Output "Auth.Log File Summary Report"
Write-Output "+--------------------------+"
if ($WasExtracted -eq "True") {
Write-Output "Log Name:   $Log (Extracted From: $GZipName)"
}
else {
Write-Output "Log Name:   $Log"
}
Write-Output "Hostname:   $hostname"
Write-Output "Log Size:   $log_size"
Write-Output "Start Time: $start_time"
Write-Output "End Time:   $end_time"
Write-Output "Duration:   $full_duration_file_summary_report"

#endregion

# run time
if ($Mode -eq "Developer") {
$file_summary_report_run_time = stop_time -start_time $file_summary_report_start_time
$file_summary_report_run_time
}