# variable to get auth.log copy content.
$AuthLogCopyContent = Get-Content "$RunningPath\02-LogModules\Auth.Log\01-LogCopy\Auth.Log.Parser.Copy.txt"

# Hashtable for successful SSH
$Successful_SSH_HashTable = @{
    "format_1" = @()
    "format_2" = @()
}

# create a hashtable for failed ssh.
$Failed_SSH_Login_HT = @{}

# flag for the failed ssh table to print nothing if its empty.
$UsernameFlag = "False"

# Foreach loop to iterate through lines of the auth.log file.
foreach ($SingleLine in $AuthLogCopyContent) {

    # Variable to find a pattern of successful SSH
    $Format_1 = $SingleLine | Select-String -Pattern ".*sshd\[[0-9]{0,15}\]\: Accepted password for.*"

    # Variable to find a pattern of successful SSH
    $Format_2 = $SingleLine | Select-String -Pattern ".*sshd\[[0-9]{0,15}\]\: Accepted publickey for.*"
    
    # Variable to find a pattern of failed SSH logins
    $Format_3 = $SingleLine | Select-String -Pattern ".*sshd\[[0-9]{0,15}\]\: Failed password for.*"
    
    # split $Format_3 in to single words and remove 'invalid user ' string
    $Words = $Format_3 -replace 'invalid user ','' -split ' '
    
    # catch the 8th word which is a username and put in a variable
    $Username = $Words[8]
    
    # if    
    if ($Username) {
    # Flag
    $UsernameFlag = "True"
    # if the table contains the $Username then add +1 to the Value  
    if ($Failed_SSH_Login_HT.ContainsKey($Username)) {
      $Failed_SSH_Login_HT[$Username]++
    }

    # if the $Username is not in there, give the value the number 1
    else {
      $Failed_SSH_Login_HT[$Username] = 1
    }
    }

    # Check if the line matches the first pattern
    if ($Format_1) {
        # Save the line to the array in the hashtable
        $Successful_SSH_HashTable["format_1"] += $Format_1.Line
        $Format_1_Count = $Successful_SSH_HashTable["format_1"].Count
    }

    # Check if the line matches the second pattern
    if ($Format_2) {
        # Save the line to the array in the hashtable
        $Successful_SSH_HashTable["format_2"] += $Format_2.Line
        $Format_2_Count = $Successful_SSH_HashTable["format_2"].Count
    }
}

# change the property name of the Keys and Values of $Failed_SSH_Login_HT
$Failed_SSH_Login_HT_Fix = foreach ($entry in $Failed_SSH_Login_HT.GetEnumerator() | Sort-Object Value -Descending) {
  [pscustomobject]@{
    "Username" = $entry.Key
    "SSH Failures" = $entry.Value
  }
}

if ($UsernameFlag -eq "True") {
# show the Failed SSH Login table
Write-Output ""
$Failed_SSH_Login_HT_Fix | Format-Table Username, "SSH Failures" | Out-String -Width 50 | ForEach-Object { $_.Trim() }
}

elseif ($UsernameFlag -eq "False") {
}

if ($Format_1_Count -ge 1) {
Write-Output ""
Write-Output "Successful SSH Password Authentication"
Write-Output "+------------------------------------+"
$Successful_SSH_HashTable["format_1"]
}

if ($Format_2_Count -ge 1) {
Write-Output ""
Write-Output "Successful SSH Public key Authentication"
Write-Output "+--------------------------------------+"
$Successful_SSH_HashTable["format_2"]
}

# reset 1
$Format_1_Count = $null

# reset 2
$Format_2_Count = $null