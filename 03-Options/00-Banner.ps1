# Dot Sorcing -> 02-AutoUpdateCheck.ps1
. "$RunningPath\03-Options\02-AutoUpdateCheck.ps1"

# ParserMaster Banner
Write-Output "    __  ___           __"
Write-Output "   /  |/  /___ ______/ /____  _____"
Write-Output '  / /|_/ / __ `/ ___/ __/ _ \/ ___/'
Write-Output " / /  / / /_/ (__  ) /_/  __/ /"
Write-Output "/_/  /_/\__,_/____/\__/\___/_/"
Write-Output "    ____"
Write-Output "   / __ \____ ______________  _____"
Write-Output '  / /_/ / __ `/ ___/ ___/ _ \/ ___/'
Write-Output " / ____/ /_/ / /  (__  )  __/ /"
Write-Output "/_/    \__,_/_/  /____/\___/_/"
Write-Output ""
Write-Output "GitHub.com/securityjoes/MasterParser"
Write-Output "        Author: Eilay Yosfan"
Write-Output ""

if ($ConnectionFlag -eq "True") {
  # if statment to comper versions
  if ($CurrentVersion -eq $Latestversion) {
    Write-Output "  This is the latest version $CurrentVersion"
    Write-Output "      No update is required."
  }

  else {
    Write-Output "        Update Available!"
    Write-Output "    You are using version $CurrentVersion"
    Write-Output "    The latest version is $latestVersion"
    Write-Output "       Update is required."
  }
}

else {
  Write-Output "           Version: $CurrentVersion"
}
