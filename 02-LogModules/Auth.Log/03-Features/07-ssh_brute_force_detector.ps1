if ($main["valid_users_failed_ssh"] -ge 1 -or $main["invalid_users_failed_ssh"]) {

  # merge valid and invalid to 1 hashtable
  $valid_fails = $main["valid_users_failed_ssh"]
  $invalid_fails = $main["invalid_users_failed_ssh"]
  $merged_hashtable = $valid_fails + $invalid_fails

  # create IP profiles
  $ip_profiles = @{}
  $users_db = @{}
  foreach ($event in $merged_hashtable) {
    # extract the ip address
    $ip = $event -replace '.*for.*from (.+?)\s+.*','$1'

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
      if ($event -match "for invalid user") {
        $user = $event -replace '.*for invalid user ','' -replace ' from.*port.*',''
        $user = "| x $user"
      }
      else {
        $user = $event -replace '.*password for ','' -replace ' from.*port.*',''
        $user = "| v $user"
      }


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
        "SSH Fail Count" = $users_db[$user]
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
