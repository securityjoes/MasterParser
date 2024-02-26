# Hashtable for successful SSH
$ElevatedActivitys_HT = @{
  "Session_Opened_For" = @()
  "ElevatedCommands" = @()
}

# variable to get auth.log copy content.
$AuthLogCopyContent = Get-Content "$RunningPath\02-LogModules\Auth.Log\01-LogCopy\Auth.Log.Parser.Copy.txt"

# Foreach loop to iterate through lines of the auth.log file.
foreach ($SingleLine in $AuthLogCopyContent) {

  # Variable to store the catches
  $Elevated_Sessions_Opened = $SingleLine | Select-String -Pattern ".*sudo\: pam_unix\(sudo\:session\)\: session opened for user.*"

  # Check if the line matches the pattern
  if ($Elevated_Sessions_Opened) {

    # Split $ElevatedActivity line into words
    $Words = $Elevated_Sessions_Opened -split ' '

    # name the words in a new variable
    $Month = $Words[0]
    $Day = $Words[1]
    $Time = $Words[2]
    $Session_Opened_For = $Words[10] -replace '\(.*',''
    $Session_Opened_By = $Words[12] -replace '\(.*',''

    # save the complte result in a variable
    $Elevated_Sessions_Opened = "$Month $Day $Time session opened for user $Session_Opened_For by $Session_Opened_By"

    # Save the line to the array in the hashtable
    $ElevatedActivitys_HT["Session_Opened_For"] += $Elevated_Sessions_Opened
    $Elevated_Sessions_Opened_Count = $ElevatedActivitys_HT["Session_Opened_For"].Count
  }

  # Variable to store the catches
  $ElevatedCommands = $SingleLine | Select-String -Pattern ".*(sudo|su)\:.*COMMAND\=.*"

  # Check if the line matches the first pattern
  if ($ElevatedCommands) {
    # Save the line to the array in the hashtable
    $ElevatedActivitys_HT["ElevatedCommands"] += $ElevatedCommands.Line
    $ElevatedCommands_Count = $ElevatedActivitys_HT["ElevatedCommands"].Count
  }

}

if ($Elevated_Sessions_Opened_Count -ge 1) {
    
    if ($TypeFlag -match "All" -or $TypeFlag -match "Raw") {
    Write-Output ""
    Write-Output "Elevated Sessions Opened For Users - Raw Table"

    # variable to cretae the amount of spaces needed for the table
    $MaxLength = ($ElevatedActivitys_HT["Session_Opened_For"] | Measure-Object Length -Maximum).Maximum

    # variable to story the new amount of hyfens
    $Border = '-' * $MaxLength

    foreach ($Event in $ElevatedActivitys_HT["Session_Opened_For"]) {

      # add space to the right of each event iteration
      $Event = $Event.PadRight($MaxLength)

      Write-Output "+$Border+"
      Write-Output "|$Event|"

    }
    Write-Output "+$Border+"
  }

  if ($TypeFlag -match "All" -or $TypeFlag -match "Statistics") {
    
    if ($TypeFlag -match "All") {
    Write-Output "|"
    Write-Output "V"
    Write-Output "Elevated Sessions Opened For Users - Statistics Table"
    }
    elseif ($TypeFlag -match "Statistics") {
    Write-Output ""
    Write-Output "Elevated Sessions Opened For Users - Statistics Table"
    }

    $Session_HT = @{}

    # Count occurrences of sessions
    foreach ($Event in $ElevatedActivitys_HT["Session_Opened_For"]) {
        $Session = $Event -replace '.*session opened for user ',''

        if ($Session_HT.ContainsKey($Session)) {
            $Session_HT[$Session]++
        }
        else {
            $Session_HT[$Session] = 1
        }
    }

    # Find max lengths
    $MaxCharKey = ($Session_HT.Keys | Measure-Object Length -Maximum).Maximum
    $MaxCharValue = ($Session_HT.Values | Measure-Object -Maximum).Maximum.ToString().Length

    # flag to stop $Border iteration after first iteration
    $Flag = "Enable"

    # Output table
    foreach ($Key in $Session_HT.Keys) {
        $SpacedKey = $Key.PadRight($MaxCharKey)
        $SpacedValue = $Session_HT[$Key].ToString().PadRight($MaxCharValue)

        $Final = "| Sessions opened for user $SpacedKey | Session Count: $SpacedValue |"
        $Border = '-' * ($Final.Length - 2)

        # Print the boarder once
        if ($Flag -match "Enable") {
        Write-Output "+$Border+"
        $Flag = "Disable"
        }

        Write-Output "$Final"
    }

    Write-Output "+$Border+"
}
}

# print out the ElevatedCommands list
if ($ElevatedCommands_Count -ge 1) {

  if ($TypeFlag -match "All" -or $TypeFlag -match "Raw") {   

  # space
  Write-Output ""
  Write-Output "Elevated Commands - Raw Events"

  # variable to cretae the amount of spaces needed for the table
  $MaxLength = ($ElevatedActivitys_HT["ElevatedCommands"] | Measure-Object Length -Maximum).Maximum

  # variable to story the new amount of hyfens
  $BorderHyphen = '-' * $MaxLength

  # foreach loop to print out all the events
  foreach ($SingleEvent in $ElevatedActivitys_HT["ElevatedCommands"]) {

    $EventsPlusSpace = $SingleEvent.PadRight($MaxLength)
    Write-Output "+$BorderHyphen+"
    Write-Output "|$EventsPlusSpace|"
  }

  # closing border hyphen
  Write-Output "+$BorderHyphen+"

  }

  if ($TypeFlag -match "All" -or $TypeFlag -match "Statistics") { 

  # hashtable
  $ElevatedCommandsHT = @{}

  foreach ($SingleEvent in $ElevatedActivitys_HT["ElevatedCommands"]) {

    # Extract the user name to a variable
    $RemoveStartUser = $SingleEvent -replace '.* sudo\:\s+',''
    $User = $RemoveStartUser -replace ' : .*',''

    # Extract the RunAs user to a variable
    $RemoveStartRunAs = $SingleEvent -replace '.*USER\=',''
    $RunAsUser = $RemoveStartRunAs -replace ' \; COMMAND\=.*',''

    # Extract time of each event
    $EventDate = $SingleEvent -replace " $Hostname.*",""

    # Extract the elevated command
    $Command = $SingleEvent -replace '.*COMMAND\=',''
    $Command = " $EventDate " + "| $Command "

    # How the User and RunAs user will be shown
    $NameTag = "| User:$User | RunAs: $RunAsUser |"

    # Check if $NameTag key already exists in the hashtable
    if ($ElevatedCommandsHT.ContainsKey($NameTag)) {
      # If it exists, append $Command to the existing array
      $ElevatedCommandsHT[$NameTag] += $Command
    } else {
      # If it doesn't exist, create a new array with $Command
      $ElevatedCommandsHT[$NameTag] = @($Command)
    }
  }

  if ($TypeFlag -match "All") {
  # title for the Statistics table
  Write-Output "|"
  Write-Output "V"
  Write-Output "Elevated Commands - Per User Statistics Table"
  }
  elseif ($TypeFlag -match "Statistics") {
  Write-Output ""
  Write-Output "Elevated Commands - Per User Statistics Table"
  }

  # flag for the space 
  $NumberFlag = "False"

  # foreach loop to iterate all the keys insidde $ElevatedCommandsHT hashtable
  foreach ($Key in $ElevatedCommandsHT.Keys) {

    # Find the maximum character count in $Key which is the $NameTag 
    $MaxCharCountForUser = ($Key | Measure-Object Length -Maximum).Maximum

    # remove '2' from the $MaxCharCountForUser value
    $MaxCharCountForUser = $MaxCharCountForUser - 2

    # variable to stor the hyfens
    $BorderHyphenForUser = '-' * $MaxCharCountForUser

    # the printing of the $NameTag plus the table
    if ($NumberFlag -match "True") {
    Write-Output ""
    }

    # for the space in the output
    $NumberFlag = "True"

    Write-Output "+$BorderHyphenForUser+"
    Write-Output "$Key"
    Write-Output "+$BorderHyphenForUser+"
    Write-Output "|"

    # Find the maximum character count in $ElevatedCommandsHT[$Key] which is the commands 
    $MaxCharCount = ($ElevatedCommandsHT[$Key] | Measure-Object Length -Maximum).Maximum

    # variable to stor the hyfens
    $BorderHyphen = '-' * $MaxCharCount

    # add the spaces to the right side of the $Commands variable
    $Commands = $ElevatedCommandsHT[$Key].PadRight($MaxCharCount)

    # the printing of the whole table with the commands
    Write-Output "+--+$BorderHyphen+"
    
    foreach ($Command in $Commands) {
      
      Write-Output "   |$Command|"
    }
    Write-Output "   +$BorderHyphen+"
  }
}
}

# reset
$Elevated_Sessions_Opened_Count = $null
$ElevatedCommands_Count = $null
$NumberTable = $null