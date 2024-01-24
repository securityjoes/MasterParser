# variable to get auth.log copy content.
$AuthLogCopyContent = Get-Content "$RunningPath\02-LogModules\Auth.Log\01-LogCopy\Auth.Log.Parser.Copy.txt"

# Foreach loop to iterate through lines of the auth.log file.
foreach ($SingleLine in $AuthLogCopyContent) {

    # Variable to find a pattern of successful SSH
    $AuthenticationFailure = $SingleLine | Select-String -Pattern ".*vsftpd\: pam_unix\(vsftpd:auth\)\: authentication failure.*"

        # Check if the line matches the first pattern
    if ($Format_1) {
        # Save the line to the array in the hashtable
        $Successful_SSH_HashTable["format_1"] += $Format_1.Line
        $Format_1_Count = $Successful_SSH_HashTable["format_1"].Count
        }

}