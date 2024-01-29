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

# print out the Session_Opened_For list
if ($Elevated_Sessions_Opened_Count -ge 1) {
Write-Output ""
Write-Output "Elevated Sessions Opened For Users"
Write-Output "+--------------------------------+"
$ElevatedActivitys_HT["Session_Opened_For"]
}

# print out the ElevatedCommands list
if ($ElevatedCommands_Count -ge 1) {
    
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
    
    # foreach loop to iterate all the keys insidde $ElevatedCommandsHT hashtable
    foreach ($Key in $ElevatedCommandsHT.Keys) {

    # Find the maximum character count in $Key which is the $NameTag 
    $MaxCharCountForUser = ($Key | Measure-Object Length -Maximum).Maximum

    # remove '2' from the $MaxCharCountForUser value
    $MaxCharCountForUser = $MaxCharCountForUser - 2
    
    # variable to stor the hyfens
    $BorderHyphenForUser = '-' * $MaxCharCountForUser

    # the printing of the $NameTag plus the table
    Write-Output "    |"
    Write-Output "    +--+"
    Write-Output "       |"
    Write-Output "       V User Information:"
    Write-Output "       +$BorderHyphenForUser+"
    Write-Output "       $Key"
    Write-Output "       +$BorderHyphenForUser+"

    # Find the maximum character count in $ElevatedCommandsHT[$Key] which is the commands 
    $MaxCharCount = ($ElevatedCommandsHT[$Key] | Measure-Object Length -Maximum).Maximum
    
    # variable to stor the hyfens
    $BorderHyphen = '-' * $MaxCharCount

    # add the spaces to the right side of the $Commands variable
    $Commands = $ElevatedCommandsHT[$Key].PadRight($MaxCharCount)

    # the printing of the whole table with the commands
    Write-Output "       |"
    Write-Output "       +--+"
    Write-Output "          |"
    Write-Output "          V Total User Executions: $($ElevatedCommandsHT[$Key].Count)"
    Write-Output "    +$BorderHyphen+"
    foreach ($Command in $Commands) {
    Write-Output "    |$Command|"
    Write-Output "    +$BorderHyphen+"
    }
    }

}

# reset
$Elevated_Sessions_Opened_Count = $null
$ElevatedCommands_Count = $null