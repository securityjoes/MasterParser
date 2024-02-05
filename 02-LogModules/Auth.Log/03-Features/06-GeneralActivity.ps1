# variable to get auth.log copy content.
$AuthLogCopyContent = Get-Content "$RunningPath\02-LogModules\Auth.Log\01-LogCopy\Auth.Log.Parser.Copy.txt"

# Hashtable for general activity
$GeneralActivity_HT = @{
    "PowerButton" = @()
    }

# Foreach loop to iterate through lines of the auth.log file.
foreach ($SingleLine in $AuthLogCopyContent) {
    
    # Variable to find a pattern of "PowerButton" action.
    $PowerButton = $SingleLine | Select-String -Pattern ".*systemd-logind\[[0-9]{0,15}\]\: Watching system buttons on .* \(Power Button\).*"
    
    # Check if the line matches the first pattern
    if ($PowerButton) {
        # Save the line to the array in the hashtable
        $GeneralActivity_HT["PowerButton"] += $PowerButton.Line
        $PowerButton_Count = $GeneralActivity_HT["PowerButton"].Count
    }
    }

# print out the Power Button activity
if ($PowerButton_Count -ge 1) {
Write-Output ""
Write-Output "Machine Shutdown By Power Button - Raw Events"

# variable to cretae the amount of spaces needed for the table
$MaxLength = ($GeneralActivity_HT["PowerButton"] | Measure-Object Length -Maximum).Maximum

# variable to story the new amount of hyfens
$Border = '-' * $MaxLength

    foreach ($Event in $GeneralActivity_HT["PowerButton"]) {
        
        # add space to the right of each event iteration
        $Event = $Event.PadRight($MaxLength)

        Write-Output "+$Border+"
        Write-Output "|$Event|"
    
    }
    Write-Output "+$Border+"
}

# reset
$PowerButton_Count = $null