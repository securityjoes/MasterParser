# flag number 1
$Flag1 = "True"

# variable to get auth.log copy content.
$AuthLogCopyContent = Get-Content $AuthLogCopyLocation

# foreach loop to iterate through lines of the auth.log file.
foreach ($SingleLine in $AuthLogCopyContent) {

  # Split each line into words
  $Words = $SingleLine -split ' '

  # if statment with a $Flag1, if true execute this.
  if ($Flag1 -eq "True") {
    $Flag1 = "false"

    # variable to save the start time of the auth.log
    $Start_Time = $words[1] + "-" + $words[0] + "-" + $words[2]

    # get the hostname from the auth.log file
    $Hostname = $words[3]
  }

  # variable to save the end time of the auth.log
  $End_Time = $words[1] + "-" + $words[0] + "-" + $words[2]

}

# get file size in bytes
$fileSizeInBytes = (Get-Item $AuthLogPath).length

# convert bytes to megabytes and format the output
$FileSizeInMB = "{0:N3}" -f ($fileSizeInBytes / 1MB)

# if statment to check if the date days has 1 or 2 numbers
# if there is 1 number
if ($Start_Time[1] -eq "-") {
  $StartTimeConverted = [datetime]::ParseExact($Start_Time,'d-MMM-HH:mm:ss',$null)
}

# if there is 2 number
else {
  $StartTimeConverted = [datetime]::ParseExact($Start_Time,'dd-MMM-HH:mm:ss',$null)
}

# if statment to check if the date days has 1 or 2 numbers
# if there is 1 number
if ($End_Time[1] -eq "-") {
  $EndTimeConverted = [datetime]::ParseExact($End_Time,'d-MMM-HH:mm:ss',$null)
}

# if there is 2 number
else {
  $EndTimeConverted = [datetime]::ParseExact($End_Time,'dd-MMM-HH:mm:ss',$null)
}

# calculate the duration
$Duration = $EndTimeConverted - $StartTimeConverted
$FullDuration = Write-Output "$($Duration.Days) Days $($Duration.Hours) Hours $($Duration.Minutes) Minutes $($Duration.Seconds) Seconds"

# the start of the report print out
Write-Output "Auth.Log File Summary Report"
Write-Output "+--------------------------+"
Write-Output "Hostname:   $Hostname"
Write-Output "Log Size:   $FileSizeInMB MB"
Write-Output "Start Time: $Start_Time"
Write-Output "End Time:   $End_Time"
Write-Output "Duration:   $FullDuration"
