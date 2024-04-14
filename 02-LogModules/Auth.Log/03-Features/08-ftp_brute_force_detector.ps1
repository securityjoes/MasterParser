if ($main["ftp"].Count -ge 1) {
    
  $ftp_hashtable = $main["ftp"]

  # create IP profiles
  $ip_profiles = @{}
  $users_db = @{}
  foreach ($event in $ftp_hashtable) {
    # extract the ip address
    $ip = $event -replace '.*rhost=::ffff:','' -replace '( user=.*|)',''

    # create a list for each IP if it doesn't exist
    if (-not $ip_profiles.ContainsKey($ip)) {
      $ip_profiles[$ip] = @{
        "Events" = @()
        "Count" = 0
      }
    }

    # add the event to the list for the IP
    $ip_profiles[$ip]["Events"] += $event
    $ip_profiles[$ip]["Count"]++
  }

  # foreach loop to iterate the ip addresses count
  foreach ($ip_address in $ip_profiles.Keys) {
    $ip_count = $ip_profiles[$ip_address]["Count"]

    # iterate and add sign to users for valid and invalid users
    foreach ($event in $ip_profiles[$ip_address]["Events"]) {
        
        $user = $event -replace '.*ruser=','' -replace ' rhost=.*',''
        $user = "| $user"

        if ($users_db.ContainsKey($user)) {
            $users_db[$user]++
        }
        else {
            $users_db[$user] = 1
        }
        }

    # Convert $users_db to custom objects with "User Name" and "Count" headers
    $users_output = @()
    foreach ($user in $users_db.Keys) {
      $user_object = [pscustomobject]@{
        "User Name" = $user
        "FTP Fail Count" = $users_db[$user]
      }
      $users_output += $user_object
    }

    # Output the custom objects
    $users_output = $users_output | Format-Table -AutoSize | Out-String #| ForEach-Object { $_ -replace '---------- --------------', '├--------- --------------' }

    Write-Output ""
    $users_output.Trim()
    Write-Output "|"
    Write-Output "└> From: $ip_address"

    # Reset $users_db for the next iteration
    $users_db = @{}
  }
}
