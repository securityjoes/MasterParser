# get the location of where the script was executed from.
$ScriptLocationPath = Get-Location

# auth.log copy location
$AuthLogCopyLocation = "$ScriptLocationPath\01-LogCopy\Auth.Log.Parser.Copy.txt"

# create a copy of the Auth.Log file
Copy-Item -Path $AuthLogPath -Destination $AuthLogCopyLocation

# variable to get auth.log content.
$AuthLogContent = Get-Content $AuthLogCopyLocation

# array to store modified lines
$ModifiedLines = @()

# get a sample of the first line of the auth.log
$One_Line_sample = $AuthLogContent[1]

# Creating a hashtable with the first three letters of month names
$monthHashtable = @{
    '01' = 'Jan';
    '02' = 'Feb';
    '03' = 'Mar';
    '04' = 'Apr';
    '05' = 'May';
    '06' = 'Jun';
    '07' = 'Jul';
    '08' = 'Aug';
    '09' = 'Sep';
    '10' = 'Oct';
    '11' = 'Nov';
    '12' = 'Dec';
}

# statement to check if TimePatch is needed
if ($One_Line_sample | Select-String -Pattern "[0-9]{4,4}\-") {

    # flag to disable "CreateLogCopy.ps1" dot sourcing
    $CreateLogCopy_Flag = "False"

# foreach loop to iterate through lines of the auth.log file.
foreach ($SingleLine in $AuthLogContent) {
    $SingleLine = $SingleLine -replace '  ',' '
    $SingleWord = $SingleLine -split ' '
    $FullTime = $SingleWord[0]
    $MonthNumber = $FullTime.Split('-')[1]
    $MonthName = $monthHashtable[$MonthNumber]
    $RemoveYear = $FullTime -replace '[0-9]{4,4}\-',''
    $Remove_Dash = $RemoveYear -replace '-',' '
    $Remove_T = $Remove_Dash -replace 'T',' '
    $remove_Dot = $Remove_T -replace '\..*',''

    # Remove $SingleWord[0] from $SingleWord
    $SingleWord = $SingleWord -ne $SingleWord[0]

    # Replace the numeric month with the three-letter month name
    $remove_Dot = $remove_Dot -replace "$MonthNumber", $MonthName

    # Join $remove_Dot and $SingleWord to be a line of words
    $ResultLine = $remove_Dot + ' ' + ($SingleWord -join ' ')

    # add the modified line to the array
    $ModifiedLines += $ResultLine
    }
}
else {
    
    # flag to enable "CreateLogCopy.ps1" dot sourcing
    $CreateLogCopy_Flag = "True"
    Remove-Item -Path $AuthLogCopyLocation
}

# save the modified lines to the new file
$ModifiedLines | Out-File -FilePath $AuthLogCopyLocation -Force

