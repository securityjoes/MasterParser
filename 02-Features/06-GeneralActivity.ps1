# Variable to get auth.log copy content.
$AuthLogCopyContent = Get-Content $AuthLogCopyLocation

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
Write-Output "Machine Shutdown By Power Button"
Write-Output "+------------------------------+"
$GeneralActivity_HT["PowerButton"]
}

else {
$NotFoundHashTable['NoPowerButton'] = "[*] Not Found: Machine Shutdown By Power Button."
}