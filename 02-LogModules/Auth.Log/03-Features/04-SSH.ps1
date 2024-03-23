# Parsing Engine
#region
# Hashtable for successful SSH
$SSH_HashTable = @{
    "format_1" = @()
    "format_2" = @()
    "format_3" = @()
}

# Pre-compile the regular expression pattern
$CombinedPattern = ".*sshd\[[0-9]{0,15}\]\: (Accepted password for|Accepted publickey for|Failed password for).*"
$Regex = [regex]::new($CombinedPattern)

# Read the content of the file
$logContent = Get-Content -Path "$RunningPath\02-LogModules\Auth.Log\01-LogCopy\Auth.Log.Parser.Copy.txt"

# Temporary arrays to hold matched lines
$Format1Lines = @()
$Format2Lines = @()
$Format3Lines = @()

# Loop through each line and match against the combined pattern
foreach ($line in $logContent) {
    if ($Regex.IsMatch($line)) {
        $matchedText = $Regex.Match($line).Value
        switch -Regex ($matchedText) {
            "Accepted password for" {
                $Format1Lines += $line
            }
            "Accepted publickey for" {
                $Format2Lines += $line
            }
            "Failed password for" {
                $Format3Lines += $line
            }
        }
    }
}

# Assign collected lines to the hashtable
$SSH_HashTable["format_1"] = $Format1Lines
$SSH_HashTable["format_2"] = $Format2Lines
$SSH_HashTable["format_3"] = $Format3Lines

# Update counts
$Format_1_Count = $Format1Lines.Count
$Format_2_Count = $Format2Lines.Count
$Format_3_Count = $Format3Lines.Count
#endregion

# Statistics Table Function
#region
function ssh_function {
    param (
        [string]$Format_Count,
        [hashtable]$hashtable,
        [string]$format_number,
        [string]$change_regex_string,
        [string]$change_title
    
    )

    if ($Format_Count -ge 1) {
        
        if ($TypeFlag -match "All" -or $TypeFlag -match "Raw") {
        Write-Output ""
        Write-Output "$change_title - Raw Table"

        # variable to create the amount of spaces needed for the table
        $MaxLength = ($hashtable[$format_number] | Measure-Object Length -Maximum).Maximum

        # variable to store the new amount of hyphens
        $Border = '-' * $MaxLength

        foreach ($Event in $hashtable[$format_number]) {
            # add space to the right of each event iteration
            $Event = $Event.PadRight($MaxLength)

            Write-Output "+$Border+"
            Write-Output "|$Event|"
        }
        Write-Output "+$Border+"
    }

        if ($TypeFlag -match "All" -or $TypeFlag -match "Statistics") {

        # Initialize variables to store maximum lengths
        $MaxChar_TimeAndDate = 0
        $MaxChar_User = 0
        $MaxChar_IP = 0
        $MaxChar_Port = 0

        # foreach loop to iterate and past each event separate from the hashtable
        foreach ($Event in $hashtable[$format_number]) {

          # creating variable for the timestamp
          $TimeAndDate = $Event -replace " $Hostname.*",""
          # creating a variable for the user
          $RemoveStart = $Event -replace ".*$change_regex_string ",""
          $User = $RemoveStart -replace " from.*",""
          # creating a variable for the IP
          $RemoveStart = $Event -replace ".* from ",""
          $IP = $RemoveStart -replace " port.*",""
          # creating a variable for the Port
          $RemoveStart = $Event -replace '.* port ',''
          $Port = $RemoveStart -replace ' ssh.*',''

          # Update max lengths if necessary
          $MaxChar_TimeAndDate = [math]::Max($MaxChar_TimeAndDate,$TimeAndDate.Length)
          $MaxChar_User = [math]::Max($MaxChar_User,$User.Length)
          $MaxChar_IP = [math]::Max($MaxChar_IP,$IP.Length)
          $MaxChar_Port = [math]::Max($MaxChar_Port,$Port.Length)
        }

        if ($TypeFlag -match "All") {
          # Strings for the top title of the Statistics Table
          Write-Output "|"
          Write-Output "V"
          Write-Output "$change_title - Statistics Table"
        }
        elseif ($TypeFlag -match "Statistics") {
          Write-Output ""
          Write-Output "$change_title - Statistics Table"
        }

        # flag to stop $Border iteration after first iteration
        $Flag = "Enable"

        # foreach loop to iterate and past each event separate from the hashtable
        foreach ($Event in $hashtable[$format_number]) {

          # creating variable for the timestamp
          $TimeAndDate = $Event -replace " $Hostname.*",""
          # creating a variable for the user
          $RemoveStart = $Event -replace ".*$change_regex_string ",""
          $User = $RemoveStart -replace " from.*",""
          # creating a variable for the IP
          $RemoveStart = $Event -replace ".* from ",""
          $IP = $RemoveStart -replace " port.*",""
          # creating a variable for the Port
          $RemoveStart = $Event -replace '.* port ',''
          $Port = $RemoveStart -replace ' ssh.*',''

          $TimeAndDate = $TimeAndDate.PadRight($MaxChar_TimeAndDate)
          $User = $User.PadRight($MaxChar_User)
          $IP = $IP.PadRight($MaxChar_IP)
          $Port = $Port.PadRight($MaxChar_Port)

          # Output the result for the current event
          $Result = Write-Output "| Time: $TimeAndDate | Event: $change_title | For User: $User | From IP: $IP | Source Port: $Port |"

          # multiply $Result.Length with "-" hyfen symbol to get the boarder
          $Border = '-' * ($Result.Length - 2)

          # print the result in a table
          if ($Flag -match "Enable") {
            Write-Output "+$Border+"
            $Flag = "Disable"
          }

          Write-Output "$Result"
        }

        Write-Output "+$Border+"
      }
 }
}
#endregion

# Print All Formats
#region

    ssh_function -Format_Count $Format_1_Count -hashtable $SSH_HashTable -format_number "format_1" -change_regex_string "Accepted password for" -change_title "Successful SSH Password Authentication"

    ssh_function -Format_Count $Format_2_Count -hashtable $SSH_HashTable -format_number "format_2" -change_regex_string "Accepted publickey for" -change_title "Successful SSH Public key Authentication"

    ssh_function -Format_Count $Format_3_Count -hashtable $SSH_HashTable -format_number "format_3" -change_regex_string "Failed password for" -change_title "Failed SSH Password Authentication"

# reset count
$Format_1_Count = $null
$Format_2_Count = $null
$Format_3_Count = $null
#endregion