# variable to get auth.log copy content.
$AuthLogCopyContent = Get-Content "$RunningPath\02-LogModules\Auth.Log\01-LogCopy\Auth.Log.Parser.Copy.txt"

# Hashtable for successful SSH
$FTP_HT = @{
  "AuthenticationFailure" = @()
}

# Foreach loop to iterate through lines of the auth.log file.
foreach ($SingleLine in $AuthLogCopyContent) {

  # Variable to find a pattern of successful SSH
  $AuthenticationFailure = $SingleLine | Select-String -Pattern ".*vsftpd\: pam_unix\(vsftpd:auth\)\: authentication failure.*"

  # List of regex to find pattern of authentication failures formats
  $AuthenticationFailureFormats = @(

    # FTP authentication failure - Format 1
    ".*vsftpd\: pam_unix\(vsftpd:auth\)\: authentication failure.*",

    # FTP authentication failure - Format 2
    ".*vsftpd\: pam_unix\(vsftpd:auth\)\:.*user unknown.*",

    # FTP authentication failure - Format 3
    ".*vsftpd\: pam_.*.*\(vsftpd:auth\)\: Refused user.*"

  )

  foreach ($AuthenticationFailureFormat in $AuthenticationFailureFormats) {

    # Variable to store the catches
    $AuthenticationFailure = $SingleLine | Select-String -Pattern $AuthenticationFailureFormat

    # Check if the line matches the first pattern
    if ($AuthenticationFailure) {
      # Save the line to the array in the hashtable
      $FTP_HT["AuthenticationFailure"] += $AuthenticationFailure.Line
      $AuthenticationFailure_Count = $FTP_HT["AuthenticationFailure"].Count

    }
  }
}

$ActivateTableFlag = "False"

# if statment to check if there is at least 1 event
if ($AuthenticationFailure_Count -ge 1) {
    
  $ActivateTableFlag = "True"
    
  # title
  Write-Output ""
  Write-Output "FTP Authentication Failure - Raw Table"

  # variable to cretae the amount of spaces needed for the table
  $maxLength = ($FTP_HT["AuthenticationFailure"] | Measure-Object Length -Maximum).Maximum

  # variable to story the hyfens
  $longBorderHyphen = '-' * $maxLength

  # foreach loop to print out all the FTP authentication failure
  foreach ($singleEvent in $FTP_HT["AuthenticationFailure"]) {

    $singleEventPlusSpace = $singleEvent.PadRight($maxLength)
    Write-Output "+$longBorderHyphen+"
    Write-Output "|$singleEventPlusSpace|"
    
  }
  # end of the table line
  Write-Output "+$longBorderHyphen+"
}

$UsernameCounts1 = @{}
$UsernameCounts2 = @{}

if ($ActivateTableFlag -eq "True") {

$FTP_HT["AuthenticationFailure"] | ForEach-Object {
    if ($_ -match $AuthenticationFailureFormats[0]) {
        $UserName = ($_ -replace '.*ruser=','') -replace ' rhost=.*',''
        $UsernameCounts1[$UserName]++
    }
    elseif ($_ -match $AuthenticationFailureFormats[2]) {
        $UserName = ($_ -replace '.* Refused user ','') -replace ' for service.*',''
        $UsernameCounts2[$UserName]++
    }
}

# Find the maximum character count in $UsernameCounts1 and $UsernameCounts2
$maxCharCount1 = ($UsernameCounts1.Keys | Measure-Object Length -Maximum).Maximum
$maxCharCount2 = ($UsernameCounts2.Keys | Measure-Object Length -Maximum).Maximum
$maxCharCount = [Math]::Max($maxCharCount1, $maxCharCount2)

$Measure_HT = $UsernameCounts1.GetEnumerator() | ForEach-Object {
    $UserName, $FailCount = $_.Key, $_.Value
    "| Event: Authentication Failure | User Name: $($UserName.PadRight($maxCharCount)) | Fail Count: $FailCount |"
}

$Measure2_HT = $UsernameCounts2.GetEnumerator() | ForEach-Object {
    $UserName, $FailCount = $_.Key, $_.Value
    "| Event: User Refused           | User Name: $($UserName.PadRight($maxCharCount)) | Fail Count: $FailCount |"
}

# calc the character count of one of the measure hash table
$CharacterCount = $Measure2_HT.Length - 2
$Hyphens = '-' * $CharacterCount

# the end output
Write-Output "                  |"
Write-Output "                  +--+"
Write-Output "                     | FTP Authentication Failure - Statistics Table"
Write-Output "       +$Hyphens+"
foreach ($OneEvent in ($Measure_HT + $Measure2_HT)) {
Write-Output "       $OneEvent"
}
Write-Output "       +$Hyphens+"

}

# reset variables
$AuthenticationFailure_Count = $null