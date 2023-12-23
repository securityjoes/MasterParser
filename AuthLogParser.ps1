# AuthLogParser Banner
Write-Output "    ___         __  __      __                "
Write-Output "   /   | __  __/ /_/ /_    / /   ____  ____ _ "
Write-Output '  / /| |/ / / / __/ __ \  / /   / __ \/ __ `/ '
Write-Output " / ___ / /_/ / /_/ / / / / /___/ /_/ / /_/ /  "
Write-Output "/_/  |_\__,_/\__/_/ /_(_)_____/\____/\__, /   "
Write-Output "       ____                         /____/    "
Write-Output "      / __ \____ ______________  _____        "
Write-Output '     / /_/ / __ `/ ___/ ___/ _ \/ ___/        '
Write-Output "    / ____/ /_/ / /  (__  )  __/ /            "
Write-Output "   /_/    \__,_/_/  /____/\___/_/             "
Write-Output ""
Write-Output "        github.com/YosfanEilay"
Write-Output "            Version: 1.0v"
Write-Output ""

# NotFoundHashTable
$NotFoundHashTable = @{}

# Variable to store where AuthLogParser is runnign from.
$RunningPath = Get-Location

# save path from execution and move variable to dot source -> CreateLogCopy.ps1
$AuthLogPath = $($args[0])

# if statment to check if $args[0] is empty
if ($AuthLogPath.Length -ge 1) {
}

# if empty, execute instructions
else {
Write-Output "[!] Auth.Log file not found."
Start-Sleep -Milliseconds 500
Write-Output "How to execute AuthLogParser ?"
Start-Sleep -Milliseconds 500
Write-Output "+----------------------------------------------------------------------------------------+"
Write-Output "| PS C:\Users\{user}\Desktop\AuthLogParser> .\AuthLogParser.ps1 C:\PATH\TO\Auth.Log\File |"
Write-Output "+----------------------------------------------------------------------------------------+"
Write-Output ""
Start-Sleep -Milliseconds 500
exit
}

# Dot Sourcing -> 01-TimePatch.ps1
. "$RunningPath\03-TimePatch\01-TimePatch.ps1"

# if statment to check if TimePatch is needed
if ($CreateLogCopy_Flag -eq "True") {
# Dot Sourcing -> CreateLogCopy.ps1
. "$RunningPath\01-LogCopy\CreateLogCopy.ps1"
}

# Dot Sourcing -> FileSummaryReport.ps1
. "$RunningPath\02-Features\01-FileSummaryReport.ps1"

# Dot Sourcing -> 02-EventNameTable.ps1
. "$RunningPath\02-Features\02-EventNameTable.ps1"

# Dot Sourcing -> 03-IPAddressTable.ps1
. "$RunningPath\02-Features\03-IPAddressTable.ps1"

# Dot Sourcing -> 04-SSHTable.ps1
. "$RunningPath\02-Features\04-SSHTable.ps1"

# Dot Sourcing -> 01-04-UsersGroupsActivity.ps1
. "$RunningPath\02-Features\05-UsersGroupsActivity.ps1"

if ($NotFoundHashTable.Values.Count -ge 1) {
# Element That Does Not Exist in This auth.log File
Write-Output ""
Write-Output "Element That Does Not Exist in This auth.log File"
Write-Output "+-----------------------------------------------+"
$NotFoundHashTable.Values
}

# delete the auth.log copty after using it.
Start-Sleep -Seconds 1
Remove-Item -Path $AuthLogCopyLocation