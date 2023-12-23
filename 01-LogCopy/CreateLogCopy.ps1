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

# foreach loop to iterate through lines of the auth.log file.
foreach ($SingleLine in $AuthLogContent) {

  # replace 2 spaces in each line to 1 space  
  $ModifiedLine = $SingleLine -replace '  ',' '

  # add the modified line to the array
  $ModifiedLines += $ModifiedLine
}

# save the modified lines to the new file
$ModifiedLines | Out-File -FilePath $AuthLogCopyLocation -Force
