# variable to get auth.log copy content.
$AuthLogCopyContent = Get-Content "$RunningPath\02-LogModules\Auth.Log\01-LogCopy\Auth.Log.Parser.Copy.txt"

# Hashtable for successful SSH
$SSH_HashTable = @{
  "format_1" = @()
  "format_2" = @()
  "format_3" = @()
}

# Foreach loop to iterate through lines of the auth.log file.
foreach ($SingleLine in $AuthLogCopyContent) {

  # Variable to find a pattern of successful SSH
  $Format_1 = $SingleLine | Select-String -Pattern ".*sshd\[[0-9]{0,15}\]\: Accepted password for.*"

  # Variable to find a pattern of successful SSH
  $Format_2 = $SingleLine | Select-String -Pattern ".*sshd\[[0-9]{0,15}\]\: Accepted publickey for.*"

  # Variable to find a pattern of failed SSH logins
  $Format_3 = $SingleLine | Select-String -Pattern ".*sshd\[[0-9]{0,15}\]\: Failed password for.*"

  # Check if the line matches the first pattern
  if ($Format_1) {
    # Save the line to the array in the hashtable
    $SSH_HashTable["format_1"] += $Format_1.Line
    $Format_1_Count = $SSH_HashTable["format_1"].Count
  }

  # Check if the line matches the second pattern
  if ($Format_2) {
    # Save the line to the array in the hashtable
    $SSH_HashTable["format_2"] += $Format_2.Line
    $Format_2_Count = $SSH_HashTable["format_2"].Count
  }

    # Check if the line matches the second pattern
  if ($Format_3) {
    # Save the line to the array in the hashtable
    $SSH_HashTable["Format_3"] += $Format_3.Line
    $Format_3_Count = $SSH_HashTable["Format_3"].Count
  }
}





if ($Format_1_Count -ge 1) {

  if ($TypeFlag -match "All" -or $TypeFlag -match "Raw") {
    Write-Output ""
    Write-Output "Successful SSH Password Authentication - Raw Table"

    # variable to cretae the amount of spaces needed for the table
    $MaxLength = ($SSH_HashTable["format_1"] | Measure-Object Length -Maximum).Maximum

    # variable to story the new amount of hyfens
    $Border = '-' * $MaxLength

    foreach ($Event in $SSH_HashTable["format_1"]) {

      # add space to the right of each event iteration
      $Event = $Event.PadRight($MaxLength)

      Write-Output "+$Border+"
      Write-Output "|$Event|"

    }
    Write-Output "+$Border+"
  }

  if ($TypeFlag -match "All" -or $TypeFlag -match "Statistics") {

    # Initialize variables to store maximum lengths
    $MaxChar_TimeAndDate = 0
    $MaxChar_User = 0
    $MaxChar_IP = 0
    $MaxChar_Port = 0

    # foreach loop to iterate and past each event separate from the hashtable
    foreach ($Event in $SSH_HashTable["format_1"]) {

      # creating variable for the timestamp
      $TimeAndDate = $Event -replace " $Hostname.*",""
      # creating a variable for the user
      $RemoveStart = $Event -replace ".*Accepted password for ",""
      $User = $RemoveStart -replace " from.*",""
      # creating a variable for the IP
      $RemoveStart = $Event -replace ".* from ",""
      $IP = $RemoveStart -replace " port.*",""
      # creating a variable for the Port
      $RemoveStart = $Event -replace '.* port ',''
      $Port = $RemoveStart -replace ' ssh.*',''

      # Update max lengths if necessary
      $MaxChar_TimeAndDate = [math]::Max($MaxChar_TimeAndDate,$TimeAndDate.Length)
      $MaxChar_User = [math]::Max($MaxChar_User,$User.Length)
      $MaxChar_IP = [math]::Max($MaxChar_IP,$IP.Length)
      $MaxChar_Port = [math]::Max($MaxChar_Port,$Port.Length)
    }

    if ($TypeFlag -match "All") {
      # Strings for the top title of the Statistics Table
      Write-Output "|"
      Write-Output "V"
      Write-Output "Successful SSH Password Authentication - Statistics Table"
    }
    elseif ($TypeFlag -match "Statistics") {
      Write-Output ""
      Write-Output "Successful SSH Password Authentication - Statistics Table"
    }

    # flag to stop $Border iteration after first iteration
    $Flag = "Enable"

    # foreach loop to iterate and past each event separate from the hashtable
    foreach ($Event in $SSH_HashTable["format_1"]) {

      # creating variable for the timestamp
      $TimeAndDate = $Event -replace " $Hostname.*",""
      # creating a variable for the user
      $RemoveStart = $Event -replace ".*Accepted password for ",""
      $User = $RemoveStart -replace " from.*",""
      # creating a variable for the IP
      $RemoveStart = $Event -replace ".* from ",""
      $IP = $RemoveStart -replace " port.*",""
      # creating a variable for the Port
      $RemoveStart = $Event -replace '.* port ',''
      $Port = $RemoveStart -replace ' ssh.*',''

      $TimeAndDate = $TimeAndDate.PadRight($MaxChar_TimeAndDate)
      $User = $User.PadRight($MaxChar_User)
      $IP = $IP.PadRight($MaxChar_IP)
      $Port = $Port.PadRight($MaxChar_Port)

      # Output the result for the current event
      $Result = Write-Output "| Time: $TimeAndDate | Event: Successful SSH Password Authentication | For User: $User | From IP: $IP | Source Port: $Port |"

      # multiply $Result.Length with "-" hyfen symbol to get the boarder
      $Border = '-' * ($Result.Length - 2)

      # print the result in a table
      if ($Flag -match "Enable") {
        Write-Output "+$Border+"
        $Flag = "Disable"
      }

      Write-Output "$Result"
    }

    Write-Output "+$Border+"
  }

}





if ($Format_2_Count -ge 1) {

  if ($TypeFlag -match "All" -or $TypeFlag -match "Raw") {

  Write-Output ""
  Write-Output "Successful SSH Public key Authentication - Raw Table"

  # variable to cretae the amount of spaces needed for the table
  $MaxLength = ($SSH_HashTable["format_2"] | Measure-Object Length -Maximum).Maximum

  # variable to story the new amount of hyfens
  $Border = '-' * $MaxLength

  foreach ($Event in $SSH_HashTable["format_2"]) {

    # add space to the right of each event iteration
    $Event = $Event.PadRight($MaxLength)

    Write-Output "+$Border+"
    Write-Output "|$Event|"

  }
  Write-Output "+$Border+"
  }

  if ($TypeFlag -match "All" -or $TypeFlag -match "Statistics") {

  # Initialize variables to store maximum lengths
    $MaxChar_TimeAndDate = 0
    $MaxChar_User = 0
    $MaxChar_IP = 0
    $MaxChar_Port = 0

    # foreach loop to iterate and past each event separate from the hashtable
    foreach ($Event in $SSH_HashTable["format_2"]) {

      # creating variable for the timestamp
      $TimeAndDate = $Event -replace " $Hostname.*",""
      # creating a variable for the user
      $RemoveStart = $Event -replace ".*Accepted publickey for ",""
      $User = $RemoveStart -replace " from.*",""
      # creating a variable for the IP
      $RemoveStart = $Event -replace ".* from ",""
      $IP = $RemoveStart -replace " port.*",""
      # creating a variable for the Port
      $RemoveStart = $Event -replace '.* port ',''
      $Port = $RemoveStart -replace ' ssh.*',''

      # Update max lengths if necessary
      $MaxChar_TimeAndDate = [math]::Max($MaxChar_TimeAndDate,$TimeAndDate.Length)
      $MaxChar_User = [math]::Max($MaxChar_User,$User.Length)
      $MaxChar_IP = [math]::Max($MaxChar_IP,$IP.Length)
      $MaxChar_Port = [math]::Max($MaxChar_Port,$Port.Length)
    }

    if ($TypeFlag -match "All") {
      # Strings for the top title of the Statistics Table
      Write-Output "|"
      Write-Output "V"
      Write-Output "Successful SSH Public key Authentication - Statistics Table"
    }
    elseif ($TypeFlag -match "Statistics") {
      Write-Output ""
      Write-Output "Successful SSH Public key Authentication - Statistics Table"
    }

    # flag to stop $Border iteration after first iteration
    $Flag = "Enable"

    # foreach loop to iterate and past each event separate from the hashtable
    foreach ($Event in $SSH_HashTable["format_2"]) {

      # creating variable for the timestamp
      $TimeAndDate = $Event -replace " $Hostname.*",""
      # creating a variable for the user
      $RemoveStart = $Event -replace ".*Accepted publickey for ",""
      $User = $RemoveStart -replace " from.*",""
      # creating a variable for the IP
      $RemoveStart = $Event -replace ".* from ",""
      $IP = $RemoveStart -replace " port.*",""
      # creating a variable for the Port
      $RemoveStart = $Event -replace '.* port ',''
      $Port = $RemoveStart -replace ' ssh.*',''

      $TimeAndDate = $TimeAndDate.PadRight($MaxChar_TimeAndDate)
      $User = $User.PadRight($MaxChar_User)
      $IP = $IP.PadRight($MaxChar_IP)
      $Port = $Port.PadRight($MaxChar_Port)

      # Output the result for the current event
      $Result = Write-Output "| Time: $TimeAndDate | Event: Successful SSH Public key Authentication | For User: $User | From IP: $IP | Source Port: $Port |"

      # multiply $Result.Length with "-" hyfen symbol to get the boarder
      $Border = '-' * ($Result.Length - 2)

      # print the result in a table
      if ($Flag -match "Enable") {
        Write-Output "+$Border+"
        $Flag = "Disable"
      }

      Write-Output "$Result"
    }

    Write-Output "+$Border+"
  }
  }





  if ($Format_3_Count -ge 1) {

  if ($TypeFlag -match "All" -or $TypeFlag -match "Raw") {

  Write-Output ""
  Write-Output "Failed SSH Password Authentication - Raw Table"

  # variable to cretae the amount of spaces needed for the table
  $MaxLength = ($SSH_HashTable["format_3"] | Measure-Object Length -Maximum).Maximum

  # variable to story the new amount of hyfens
  $Border = '-' * $MaxLength

  foreach ($Event in $SSH_HashTable["format_3"]) {

    # add space to the right of each event iteration
    $Event = $Event.PadRight($MaxLength)

    Write-Output "+$Border+"
    Write-Output "|$Event|"

  }
  Write-Output "+$Border+"
  }

  if ($TypeFlag -match "All" -or $TypeFlag -match "Statistics") {

  # Initialize variables to store maximum lengths
    $MaxChar_TimeAndDate = 0
    $MaxChar_User = 0
    $MaxChar_IP = 0
    $MaxChar_Port = 0

    # foreach loop to iterate and past each event separate from the hashtable
    foreach ($Event in $SSH_HashTable["format_3"]) {

      # creating variable for the timestamp
      $TimeAndDate = $Event -replace " $Hostname.*",""
      # creating a variable for the user
      $RemoveStart = $Event -replace ".*Failed password for ",""
      $User = $RemoveStart -replace " from.*",""
      # creating a variable for the IP
      $RemoveStart = $Event -replace ".* from ",""
      $IP = $RemoveStart -replace " port.*",""
      # creating a variable for the Port
      $RemoveStart = $Event -replace '.* port ',''
      $Port = $RemoveStart -replace ' ssh.*',''

      # Update max lengths if necessary
      $MaxChar_TimeAndDate = [math]::Max($MaxChar_TimeAndDate,$TimeAndDate.Length)
      $MaxChar_User = [math]::Max($MaxChar_User,$User.Length)
      $MaxChar_IP = [math]::Max($MaxChar_IP,$IP.Length)
      $MaxChar_Port = [math]::Max($MaxChar_Port,$Port.Length)
    }

    if ($TypeFlag -match "All") {
      # Strings for the top title of the Statistics Table
      Write-Output "|"
      Write-Output "V"
      Write-Output "Failed SSH Password Authentication - Statistics Table"
    }
    elseif ($TypeFlag -match "Statistics") {
      Write-Output ""
      Write-Output "Failed SSH Password Authentication - Statistics Table"
    }

    # flag to stop $Border iteration after first iteration
    $Flag = "Enable"

    # foreach loop to iterate and past each event separate from the hashtable
    foreach ($Event in $SSH_HashTable["format_3"]) {

      # creating variable for the timestamp
      $TimeAndDate = $Event -replace " $Hostname.*",""
      # creating a variable for the user
      $RemoveStart = $Event -replace ".*Failed password for ",""
      $User = $RemoveStart -replace " from.*",""
      # creating a variable for the IP
      $RemoveStart = $Event -replace ".* from ",""
      $IP = $RemoveStart -replace " port.*",""
      # creating a variable for the Port
      $RemoveStart = $Event -replace '.* port ',''
      $Port = $RemoveStart -replace ' ssh.*',''

      $TimeAndDate = $TimeAndDate.PadRight($MaxChar_TimeAndDate)
      $User = $User.PadRight($MaxChar_User)
      $IP = $IP.PadRight($MaxChar_IP)
      $Port = $Port.PadRight($MaxChar_Port)

      # Output the result for the current event
      $Result = Write-Output "| Time: $TimeAndDate | Event: Failed SSH Password Authentication | For User: $User | From IP: $IP | Source Port: $Port |"

      # multiply $Result.Length with "-" hyfen symbol to get the boarder
      $Border = '-' * ($Result.Length - 2)

      # print the result in a table
      if ($Flag -match "Enable") {
        Write-Output "+$Border+"
        $Flag = "Disable"
      }

      Write-Output "$Result"
    }

    Write-Output "+$Border+"
  }
  }

# reset this variables
$Format_1_Count = $null
$Format_2_Count = $null
$Format_3_Count = $null


