# null flag
$SuccessFlag = $null

# main title print
Write-Output "MasterParser Removal Process"
Write-Output "+--------------------------+"

# variable with all the files to be removed
$AllFiles = Get-Item -Path "$RunningPath\*" | Select-Object -ExpandProperty Name

foreach ($EachFile in $AllFiles) {

# remove the file
Remove-Item -Path "$RunningPath\$EachFile" -Force -Recurse -WarningAction Continue -ErrorAction SilentlyContinue | Out-Null

# check if the file was removed, execute this if the file was not removed.
if (Test-Path -Path "$RunningPath\$EachFile") {

# print this
Write-Output "[!][Not Removed] - $RunningPath\$EachFile"
}

# execute this if the file was removed.
else {
Write-Output "[*][Removed] - $RunningPath\$EachFile"
}

}

# space
Write-Output ""

# second title print
Write-Output "MasterParser Root Folder"
Write-Output "+----------------------+"

# move back 1 directory
cd ..

# remove the file
Remove-Item -Path "MasterParser-main" -Force -Recurse -WarningAction Continue -ErrorAction SilentlyContinue | Out-Null

# execute this if the remove failed
if (Test-Path -Path $RunningPath) {

# print this
Write-Output "[!][Not Removed] - $RunningPath"

}

# execute this if the remove succeeded
else {

# print this
Write-Output "[*][Removed] - $RunningPath"

# flag
$SuccessFlag = "True"
}

# space
Write-Output ""

# 3th title print
Write-Output "Current Directory"
Write-Output "+---------------+"

# get the current directory
$CurrentDirectory = Get-Location

Write-Output "Current Directory is now - $CurrentDirectory"

# space
Write-Output ""

if ($SuccessFlag -eq "True") {

# 4th title print
Write-Output "MasterParser Removal Status"
Write-Output "+-------------------------+"
Write-Output "[*] Purge done successfully."

# space
Write-Output ""
}

else {
# 4th title print
Write-Output "MasterParser Removal Status"
Write-Output "+-------------------------+"
Write-Output "[!] Error: Some files were not removed correctly."

# space
Write-Output ""
}

# null flag
$SuccessFlag = $null