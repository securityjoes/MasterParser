# check if there is MasterParser.zip under the $RunningPath, if yes, delete it.
if (Test-Path -Path $RunningPath\MasterParser.zip) {
Remove-Item -Path $RunningPath\MasterParser.zip -Force -ErrorAction SilentlyContinue
}

# process title
Write-Output "MasterParser Update Process"
Write-Output "+--------------------------+"
Start-Sleep -Milliseconds 300
Write-Output "[*] Checking connection to GitHub."

# GitHub domain variable
$GitHub = "GitHub.com"

# test conection to GitHub domain
$ConnectionStatus = Test-Connection -ComputerName $GitHub -Count 2 -ErrorAction SilentlyContinue | Select-Object -Property *

# statment to check if the there is connection to GitHub or not
if ($ConnectionStatus) {
Start-Sleep -Milliseconds 300
Write-Output "[*] GitHub is reachable."
}

# execute this if connection to GitHub is NOT reachable
else {
Start-Sleep -Milliseconds 150
Write-Output "[!] GitHub is NOT reachable."
Start-Sleep -Milliseconds 150
Write-Output "[!] Please check your internet connection."
Start-Sleep -Milliseconds 150
Write-Output "[!] Update failed."
exit
}

# write that MasterParser-main.zip is now downloading
Start-Sleep -Milliseconds 300
Write-Output "[*] Downloading the latest MasterParser."

# invoke a web request to download the latest MasterParser ZIP file
Invoke-WebRequest https://github.com/YosfanEilay/AuthLogParser/archive/main/AuthLogParser.zip -OutFile $RunningPath\MasterParser.zip

# if statment to check if download completed successfully
if (Test-Path -Path "$RunningPath\MasterParser.zip"){
Start-Sleep -Milliseconds 300
Write-Output "[*] Download completed successfully."
}

# new file was not found after download under $RunningPath.
else {
Start-Sleep -Milliseconds 150
Write-Output "[!] New MasterParser was not found under $RunningPath"
Start-Sleep -Milliseconds 150
Write-Output "[!] Update failed."
exit
}

# variable to save all files\folders under $RunningPath\*
$MasterParserFiles = Get-Item -Path "$RunningPath\*" | Select-Object -ExpandProperty FullName

# foreach statment to iterate a removing process on all the old files\folders.
foreach ($MasterParserFile in $MasterParserFiles) {
Remove-Item -Path $MasterParserFile -Exclude ("MasterParser.zip") -Force -Recurse -WarningAction Continue -ErrorAction SilentlyContinue | Out-Null
}

# check if the remove was successful, print this if it was failed.
if (Test-Path -Path "$RunningPath\MasterParser.ps1") {
Start-Sleep -Milliseconds 150
Write-Output "[!] Removing old MasterParser was failed."
Start-Sleep -Milliseconds 150
Write-Output "[!] Update failed."
exit
}

# print this if the remove was successfull
else {
Start-Sleep -Milliseconds 150
Write-Output "[*] Old MasterParser was successfully removed."
}

# extract the content of the MasterParser.zip archive
Expand-Archive -Path "$RunningPath\MasterParser.zip" -DestinationPath $RunningPath

# check if the extraction was successfull, print this if it was successfull.
if (Test-Path -Path "$RunningPath\MasterParser-main") {
Start-Sleep -Milliseconds 150
Write-Output "[*] Extracting new MasterParser completed successfully."
}

# print this if it was failed.
else {
Start-Sleep -Milliseconds 150
Write-Output "[!] Failed to extract new MasterParser."
Start-Sleep -Milliseconds 150
Write-Output "[!] Update failed."
exit
}

# transfer all files\folders from AuthLogParser-main to MasterParser folder
Move-Item -Path "$RunningPath\MasterParser-main\*" -Destination $RunningPath

# check if the extraction of all files\folders from MasterParser-main folder was successfull, print this if it was successfull.
if (Test-Path -Path "$RunningPath\MasterParser.ps1") {
Start-Sleep -Milliseconds 150
Write-Output "[*] New MasterParser are in place."
Start-Sleep -Milliseconds 150
Write-Output "[*] Update completed successfully."
Write-Output ""
}

else {
Write-Output "[!] Some files are not in place after the update."
Start-Sleep -Milliseconds 150
Write-Output "[!] Update failed."
exit
}

# check if there is MasterParser.zip under the $RunningPath, if yes, delete it.
if (Test-Path -Path $RunningPath\MasterParser.zip) {
Remove-Item -Path $RunningPath\MasterParser.zip -Force -ErrorAction SilentlyContinue
}