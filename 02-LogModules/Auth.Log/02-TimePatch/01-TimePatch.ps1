# get the location of where the script was executed from.
$ScriptLocationPath = $RunningPath

# get the location of the original auth.log file
$AuthLogPath = "$RunningPath\01-Logs\$Log"

# auth.log copy location
$AuthLogCopyLocation = "$ScriptLocationPath\02-LogModules\Auth.Log\01-LogCopy\Auth.Log.Parser.Copy.txt"

# if $AuthLogCopyLocation is already exist, delete it
if (Test-Path -Path $AuthLogCopyLocation) {
    Remove-Item -Path $AuthLogCopyLocation -Force -ErrorAction SilentlyContinue | Out-Null
}

# create a copy of the Auth.Log file
Copy-Item -Path $AuthLogPath -Destination $AuthLogCopyLocation

# variable to get auth.log content.
$AuthLogContent = Get-Content -Head 1 -Path $AuthLogCopyLocation

# Check if TimePatch is needed
if ($AuthLogContent -match '^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}') {
    
    # variable to get auth.log content.
    $AuthLogContent = Get-Content $AuthLogCopyLocation

    # Loop through each line and convert date format
    $ModifiedLines = foreach ($line in $AuthLogContent) {
        # Split the line into timestamp and rest of the line
        $timestamp, $rest = $line -split ' ', 2

        # Extract date and time components
        $date = $timestamp.Substring(0, 10)
        $time = $timestamp.Substring(11, 8)

        # Format date and time
        $formattedDate = [datetime]::ParseExact($date, 'yyyy-MM-dd', $null).ToString('MMM dd')
        $formattedTime = $time

        # Join the formatted date, time, and the rest of the line
        $formattedDate + ' ' + $formattedTime + ' ' + $rest
    }

    # Save the modified lines to the new file
    $ModifiedLines | Set-Content -Path $AuthLogCopyLocation -Force
}
