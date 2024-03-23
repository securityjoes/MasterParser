# Hashtable to store the cleaned IP addresses
$IPHashTable = @{}

# Regular expression pattern to match both IPv4 and IPv6 addresses
$IPPattern = '\b(?:\d{1,3}\.){3}\d{1,3}\b|\b(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}\b'

# Get the content of the file directly using switch statement
switch -Regex -File "$RunningPath\02-LogModules\Auth.Log\01-LogCopy\Auth.Log.Parser.Copy.txt" {
    $IPPattern {
        # Extract the IP address from the line
        $IPAddress = $matches[0]

        # Clean the IP address
        $CleanIP = $IPAddress -replace ".*\=|\(|.*\[|\)|\]|\:.*",""

        # Update the hashtable
        if ($IPHashTable.ContainsKey($CleanIP)) {
            $IPHashTable[$CleanIP]++
        } else {
            $IPHashTable[$CleanIP] = 1
        }
    }
}

# Check if there are any IP addresses in the hashtable
if ($IPHashTable.Count -ge 1) {
    # Flag indicating IP addresses are present
    $IPHashTableFlag = "True"

    # Output the cleaned IP addresses
    Write-Output ""
    $IPHashTable.GetEnumerator() | Sort-Object Value -Descending | ForEach-Object {
        [pscustomobject]@{
            "IP Address" = $_.Key
            "Count" = $_.Value
        }
    } | Format-Table -Property "IP Address", "Count" | Out-String -Width 50 | ForEach-Object { $_.Trim() }
} else {
    # If no IP addresses are found
    $IPHashTableFlag = "False"
}
