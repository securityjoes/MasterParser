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

# print out the user authentication failure activity
if ($AuthenticationFailure_Count -ge 1) {
Write-Output ""
Write-Output "FTP Authentication Failure"
Write-Output "+------------------------+"
$FTP_HT["AuthenticationFailure"]
}

# reset variables
$AuthenticationFailure_Count = $null
