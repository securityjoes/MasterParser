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
Write-Output ""
Write-Output "Elevated Commands"
Write-Output "+---------------+"
$ElevatedActivitys_HT["ElevatedCommands"]
}

# reset
$Elevated_Sessions_Opened_Count = $null
$ElevatedCommands_Count = $null