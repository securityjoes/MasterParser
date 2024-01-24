# hashtable for Clean IP list
$IPHashTable = @{}

# variable to get auth.log copy content.
$AuthLogCopyContent = Get-Content "$RunningPath\02-LogModules\Auth.Log\01-LogCopy\Auth.Log.Parser.Copy.txt"

# foreach loop to iterate through lines of the auth.log file.
foreach ($SingleLine in $AuthLogCopyContent) {

  # Split each line into words
  $Words = $SingleLine -split ' '

  # variable to clean IP from irrelevant characters
  $IPs = $Words | Select-String -Pattern "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}"

  # clean IP variable 
  $CleanIPs = $IPs -replace ".*\=|\(|.*\[|\)|\]|\:.*",""

  # foreach loop to create a variable with single IP address
  foreach ($IP in $CleanIPs) {

    # if the table contains the $IP then add +1 to the Value  
    if ($IPHashTable.ContainsKey($IP)) {
      $IPHashTable[$IP]++
    }

    # if the $IP is not in there, give the value the number 1
    else {
      $IPHashTable[$IP] = 1
    }
  }
}

# change the property name of the Keys and Values of $IPHashTable
$IPHashTableFix = foreach ($entry in $IPHashTable.GetEnumerator() | Sort-Object Value -Descending) {
  [pscustomobject]@{
    "IP Address" = $entry.Key
    "Count" = $entry.Value
    
  }
}

if ($IPHashTable.Keys.Count -ge 1) {
# IPHashTable Flag
$IPHashTableFlag = "True"
# show the IP address table
Write-Output ""
$IPHashTableFix | Format-Table "IP Address",Count | Out-String -Width 50 | ForEach-Object { $_.Trim() }
}

else {
# If the IPHashTable.Count is 0.
$IPHashTableFlag = "False"
}

