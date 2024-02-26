# variable to get auth.log copy content.
$AuthLogCopyContent = Get-Content "$RunningPath\02-LogModules\Auth.Log\01-LogCopy\Auth.Log.Parser.Copy.txt"

# Hashtable for successful SSH
$UsersGroupActivity_HT = @{
  "useradd" = @()
  "userdel" = @()
  "ChangePassword" = @()
  "groupadd" = @()
  "groudel" = @()
  "AddUserToGroup" = @()
  "RemoveUserFromGroup" = @()
  "RootSession" = @()
  "UserInformationChange" = @()
}

# Foreach loop to iterate through lines of the auth.log file.
foreach ($SingleLine in $AuthLogCopyContent) {

  # Variable to find a pattern of "useradd" action.
  $useradd = $SingleLine | Select-String -Pattern ".*useradd\[[0-9]{0,15}\]\: new user: name=.*"

  # Check if the line matches the first pattern
  if ($useradd) {
    # Save the line to the array in the hashtable
    $UsersGroupActivity_HT["useradd"] += $useradd.Line
    $useradd_Count = $UsersGroupActivity_HT["useradd"].Count
  }

  # Variable to find a pattern of "userdel" action.
  $userdel = $SingleLine | Select-String -Pattern ".*userdel\[[0-9]{0,15}\]\: delete user.*"

  # Check if the line matches the first pattern
  if ($userdel) {
    # Save the line to the array in the hashtable
    $UsersGroupActivity_HT["userdel"] += $userdel.Line
    $userdel_Count = $UsersGroupActivity_HT["userdel"].Count
  }

  # List of regex to find pattern of password changes
  $ChangePasswordFormats = @(

    # using "passwd"
    ".* passwd\[[0-9]{0,15}\]\: .* password changed for.*",

    #using "passwd"
    ".*usermod\[[0-9]{0,15}\]\: change user.*",

    # using "chpasswd"
    ".*chpasswd\[[0-9]{0,15}\]\:.*password changed for.*"
  )

  foreach ($ChangePasswordFormat in $ChangePasswordFormats) {

    # Variable to store the catches
    $ChangePassword = $SingleLine | Select-String -Pattern $ChangePasswordFormat

    # Check if the line matches the first pattern
    if ($ChangePassword) {
      # Save the line to the array in the hashtable
      $UsersGroupActivity_HT["ChangePassword"] += $ChangePassword.Line
      $ChangePassword_Count = $UsersGroupActivity_HT["ChangePassword"].Count
    }
  }

  # Variable to find a pattern of group creation action.
  $groupadd = $SingleLine | Select-String -Pattern ".*groupadd\[[0-9]{0,15}\]\: new group\: name\=.*"

  # Check if the line matches the first pattern
  if ($groupadd) {
    # Save the line to the array in the hashtable
    $UsersGroupActivity_HT["groupadd"] += $groupadd.Line
    $groupadd_Count = $UsersGroupActivity_HT["groupadd"].Count
  }

  # Variable to find a pattern of group deletion action.
  $groudel = $SingleLine | Select-String -Pattern ".*groupdel\[[0-9]{0,15}\]\: group .* removed$"

  # Check if the line matches the first pattern
  if ($groudel) {
    # Save the line to the array in the hashtable
    $UsersGroupActivity_HT["groudel"] += $groudel.Line
    $groudel_Count = $UsersGroupActivity_HT["groudel"].Count
  }

  # Variable to find a pattern of add user to group action.
  $AddUserToGroup = $SingleLine | Select-String -Pattern ".*usermod\[[0-9]{0,15}\]\: add .* to group .*"

  # Check if the line matches the first pattern
  if ($AddUserToGroup) {
    # Save the line to the array in the hashtable
    $UsersGroupActivity_HT["AddUserToGroup"] += $AddUserToGroup.Line
    $AddUserToGroup_Count = $UsersGroupActivity_HT["AddUserToGroup"].Count
  }

  # Variable to find a pattern of remove user from group action.
  $RemoveUserFromGroup = $SingleLine | Select-String -Pattern ".*gpasswd\[[0-9]{0,15}\]\: user .* removed by .*"

  # Check if the line matches the first pattern
  if ($RemoveUserFromGroup) {
    # Save the line to the array in the hashtable
    $UsersGroupActivity_HT["RemoveUserFromGroup"] += $RemoveUserFromGroup.Line
    $RemoveUserFromGroup_Count = $UsersGroupActivity_HT["RemoveUserFromGroup"].Count
  }

  # Variable to find a pattern of user information change.
  $UserInformationChange = $SingleLine | Select-String -Pattern ".*chfn\[[0-9]{0,15}\]\: changed user .*.* information.*"

  # Check if the line matches the first pattern
  if ($UserInformationChange) {
    # Save the line to the array in the hashtable
    $UsersGroupActivity_HT["UserInformationChange"] += $UserInformationChange.Line
    $UserInformationChange_Count = $UsersGroupActivity_HT["UserInformationChange"].Count
  }

}

# print out the user creation activity
if ($useradd_Count -ge 1) {

  if ($TypeFlag -match "All" -or $TypeFlag -match "Raw") { 
    
  Write-Output ""
  Write-Output "User Creation Activity - Raw Events"

  # variable to cretae the amount of spaces needed for the table
  $MaxLength = ($UsersGroupActivity_HT["useradd"] | Measure-Object Length -Maximum).Maximum

  # variable to stor the new amount of hyfens
  $Border = '-' * $MaxLength

  # foreach loop to iterate and past each event seperate from the hashtable
  foreach ($Event in $UsersGroupActivity_HT["useradd"]) {

    # add space to the right of each event iteration
    $Event = $Event.PadRight($MaxLength)

    # print start\middle border
    Write-Output "+$Border+"

    # print each event
    Write-Output "|$Event|"

  }

  # print last border
  Write-Output "+$Border+"
  }

  if ($TypeFlag -match "All" -or $TypeFlag -match "Statistics") { 

  # Initialize variables to store maximum lengths
  $MaxChar_TimeAndDate = 0
  $MaxChar_UserCreation = 0

  # foreach loop to iterate and past each event separate from the hashtable
  foreach ($Event in $UsersGroupActivity_HT["useradd"]) {

    # creating variable for the timestamp
    $TimeAndDate = $Event -replace " $Hostname.*",""
    # creating a variable for the user creation
    $RemoveStart = $Event -replace ".*new user\: name\=",""
    $UserCreation = $RemoveStart -replace "\, UID\=.*",""

    # Update max lengths if necessary
    $MaxChar_TimeAndDate = [math]::Max($MaxChar_TimeAndDate,$TimeAndDate.Length)
    $MaxChar_UserCreation = [math]::Max($MaxChar_UserCreation,$UserCreation.Length)
  }

  if ($TypeFlag -match "All") {
  # Strings for the top title of the Statistics Table
  Write-Output "|"
  Write-Output "V"
  Write-Output "User Creation Activity - Statistics Table"
  }
  elseif ($TypeFlag -match "Statistics") {
  Write-Output ""
  Write-Output "User Creation Activity - Statistics Table"
  }

  # flag to stop $Border iteration after first iteration
  $Flag = "Enable"

  # foreach loop to iterate and past each event separate from the hashtable
  foreach ($Event in $UsersGroupActivity_HT["useradd"]) {

    # creating variable for the timestamp
    $TimeAndDate = $Event -replace " $Hostname.*",""
    # creating a variable for the user deletion
    $RemoveStart = $Event -replace ".*new user\: name\=",""
    $UserCreation = $RemoveStart -replace "\, UID\=.*",""

    $TimeAndDate = $TimeAndDate.PadRight($MaxChar_TimeAndDate)
    $UserCreation = $UserCreation.PadRight($MaxChar_UserCreation)

    # Output the result for the current event
    $Result = Write-Output "| Time: $TimeAndDate | Event: User Creation Activity | Created User Name: $UserCreation |"

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

# print out the user deletion activity
if ($userdel_Count -ge 1) {

  if ($TypeFlag -match "All" -or $TypeFlag -match "Raw") { 
    
  Write-Output ""
  Write-Output "User Deletion Activity - Raw Events"

  # variable to cretae the amount of spaces needed for the table
  $MaxLength = ($UsersGroupActivity_HT["userdel"] | Measure-Object Length -Maximum).Maximum

  # variable to stor the new amount of hyfens
  $Border = '-' * $MaxLength

  # foreach loop to iterate and past each event seperate from the hashtable
  foreach ($Event in $UsersGroupActivity_HT["userdel"]) {

    # add space to the right of each event iteration
    $Event = $Event.PadRight($MaxLength)

    # print start\middle border
    Write-Output "+$Border+"

    # print each event
    Write-Output "|$Event|"

  }

  # print last border
  Write-Output "+$Border+"

  }

  if ($TypeFlag -match "All" -or $TypeFlag -match "Statistics") { 

  # Initialize variables to store maximum lengths
  $MaxChar_TimeAndDate = 0
  $MaxChar_UserDeletion = 0

  # foreach loop to iterate and past each event separate from the hashtable
  foreach ($Event in $UsersGroupActivity_HT["userdel"]) {

    # creating variable for the timestamp
    $TimeAndDate = $Event -replace " $Hostname.*",""
    # creating a variable for the user deletion
    $RemoveStart = $Event -replace ".*delete user \'",""
    $UserDeletion = $RemoveStart -replace "\'",""

    # Update max lengths if necessary
    $MaxChar_TimeAndDate = [math]::Max($MaxChar_TimeAndDate,$TimeAndDate.Length)
    $MaxChar_UserDeletion = [math]::Max($MaxChar_UserDeletion,$UserDeletion.Length)
  }

  if ($TypeFlag -match "All") {
  # Strings for the top title of the Statistics Table
  Write-Output "|"
  Write-Output "V"
  Write-Output "User Deletion Activity - Statistics Table"
  }
  elseif ($TypeFlag -match "Statistics") {
  Write-Output ""
  Write-Output "User Deletion Activity - Statistics Table"
  }

  # flag to stop $Border iteration after first iteration
  $Flag = "Enable"

  # foreach loop to iterate and past each event separate from the hashtable
  foreach ($Event in $UsersGroupActivity_HT["userdel"]) {

    # creating variable for the timestamp
    $TimeAndDate = $Event -replace " $Hostname.*",""
    # creating a variable for the user deletion
    $RemoveStart = $Event -replace ".*delete user \'",""
    $UserDeletion = $RemoveStart -replace "\'",""

    $TimeAndDate = $TimeAndDate.PadRight($MaxChar_TimeAndDate)
    $UserDeletion = $UserDeletion.PadRight($MaxChar_UserDeletion)

    # Output the result for the current event
    $Result = Write-Output "| Time: $TimeAndDate | Event: User Deletion Activity | Deleted User Name: $UserDeletion |"

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

# print out the user Password Change Activity
if ($ChangePassword_Count -ge 1) {

  if ($TypeFlag -match "All" -or $TypeFlag -match "Raw") { 
  
  Write-Output ""
  Write-Output "User Password Change Activity - Raw Events"

  # variable to cretae the amount of spaces needed for the table
  $MaxLength = ($UsersGroupActivity_HT["ChangePassword"] | Measure-Object Length -Maximum).Maximum

  # variable to stor the new amount of hyfens
  $Border = '-' * $MaxLength

  # foreach loop to iterate and past each event seperate from the hashtable
  foreach ($Event in $UsersGroupActivity_HT["ChangePassword"]) {

    # add space to the right of each event iteration
    $Event = $Event.PadRight($MaxLength)

    # print start\middle border
    Write-Output "+$Border+"

    # print each event
    Write-Output "|$Event|"

  }

  # print last border
  Write-Output "+$Border+"

  }

  if ($TypeFlag -match "All" -or $TypeFlag -match "Statistics") { 

  # Initialize variables to store maximum lengths
  $MaxChar_TimeAndDate = 0
  $MaxChar_Command = 0
  $MaxChar_User = 0

  # foreach loop to iterate and past each event separate from the hashtable
  foreach ($Event in $UsersGroupActivity_HT["ChangePassword"]) {

    # creating variable for the timestamp
    $TimeAndDate = $Event -replace " $Hostname.*",""
    # creating a variable for password change command
    $RemoveStart = $Event -replace ".*$Hostname ",""
    $Command = $RemoveStart -replace "\[.*\].*",""
    
    # choose the correct way to capture the username
    if ($Command -match "passwd") {
        $User = $Event -replace '.*password changed for ',''
    }
    elseif ($Command-match "usermod") {
        $RemoveStart = $Event -replace ".*change user \'",""
        $User = $RemoveStart -replace "\' password.*",""
    }
    elseif($Command-match "chpasswd"){
        $User = $Event -replace '.*password changed for ',''
    }

    # Update max lengths if necessary
    $MaxChar_TimeAndDate = [math]::Max($MaxChar_TimeAndDate,$TimeAndDate.Length)
    $MaxChar_Command = [math]::Max($MaxChar_Command,$Command.Length)
    $MaxChar_User = [math]::Max($MaxChar_User,$User.Length)
  }

  # Strings for the top title of the Statistics Table
  if ($TypeFlag -match "All") {
  Write-Output "|"
  Write-Output "V"
  Write-Output "User Password Change Activity - Statistics Table"
  }

  elseif ($TypeFlag -match "Statistics"){
  Write-Output ""
  Write-Output "User Password Change Activity - Statistics Table"
  }

  # flag to stop $Border iteration after first iteration
  $Flag = "Enable"

  # foreach loop to iterate and past each event separate from the hashtable
  foreach ($Event in $UsersGroupActivity_HT["ChangePassword"]) {

    # creating variable for the timestamp
    $TimeAndDate = $Event -replace " $Hostname.*",""
    # creating a variable for password change command
    $RemoveStart = $Event -replace ".*$Hostname ",""
    $Command = $RemoveStart -replace "\[.*\].*",""
    
    # choose the correct way to capture the username
    if ($Command -match "passwd") {
        $User = $Event -replace '.*password changed for ',''
    }
    elseif ($Command-match "usermod") {
        $RemoveStart = $Event -replace ".*change user \'",""
        $User = $RemoveStart -replace "\' password.*",""
    }
    elseif($Command-match "chpasswd"){
        $User = $Event -replace '.*password changed for ',''
    }

    $TimeAndDate = $TimeAndDate.PadRight($MaxChar_TimeAndDate)
    $Command = $Command.PadRight($MaxChar_Command)
    $User = $User.PadRight($MaxChar_User)

    # Output the result for the current event
    $Result = Write-Output "| Time: $TimeAndDate | Event: Password Reset | Using The Command: $Command | User: $User |"

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

# print out the group creation
if ($groupadd_Count -ge 1) {
  
  if ($TypeFlag -match "All" -or $TypeFlag -match "Raw") {   
    
  Write-Output ""
  Write-Output "Group Creation Activity - Raw Events"

  # variable to cretae the amount of spaces needed for the table
  $MaxLength = ($UsersGroupActivity_HT["groupadd"] | Measure-Object Length -Maximum).Maximum

  # variable to stor the new amount of hyfens
  $Border = '-' * $MaxLength

  # foreach loop to iterate and past each event seperate from the hashtable
  foreach ($Event in $UsersGroupActivity_HT["groupadd"]) {

    # add space to the right of each event iteration
    $Event = $Event.PadRight($MaxLength)

    # print start\middle border
    Write-Output "+$Border+"

    # print each event
    Write-Output "|$Event|"

  }

  # print last border
  Write-Output "+$Border+"

  }

  if ($TypeFlag -match "All" -or $TypeFlag -match "Statistics") { 

  # Initialize variables to store maximum lengths
  $MaxChar_TimeAndDate = 0
  $MaxChar_CreatedGroup = 0

  # foreach loop to iterate and past each event separate from the hashtable
  foreach ($Event in $UsersGroupActivity_HT["groupadd"]) {

    # creating variable for the timestamp
    $TimeAndDate = $Event -replace " $Hostname.*",""
    # creating a variable for the created group
    $RemoveStart = $Event -replace ".*new group\: name\=",""
    $CreatedGroup = $RemoveStart -replace "\, GID\=.*",""

    # Update max lengths if necessary
    $MaxChar_TimeAndDate = [math]::Max($MaxChar_TimeAndDate,$TimeAndDate.Length)
    $MaxChar_CreatedGroup = [math]::Max($MaxChar_CreatedGroup,$CreatedGroup.Length)
  }

  if ($TypeFlag -match "All") {
  # Strings for the top title of the Statistics Table
  Write-Output "|"
  Write-Output "V"
  Write-Output "Group Creation Activity - Statistics Table"
  }

  elseif ($TypeFlag -match "Statistics"){
  Write-Output ""
  Write-Output "Group Creation Activity - Statistics Table"
  }

  # flag to stop $Border iteration after first iteration
  $Flag = "Enable"

  # foreach loop to iterate and past each event separate from the hashtable
  foreach ($Event in $UsersGroupActivity_HT["groupadd"]) {

    # creating variable for the timestamp
    $TimeAndDate = $Event -replace " $Hostname.*",""
    # creating a variable for the created group
    $RemoveStart = $Event -replace ".*new group\: name\=",""
    $CreatedGroup = $RemoveStart -replace "\, GID\=.*",""

    $TimeAndDate = $TimeAndDate.PadRight($MaxChar_TimeAndDate)
    $CreatedGroup = $CreatedGroup.PadRight($MaxChar_CreatedGroup)

    # Output the result for the current event
    $Result = Write-Output "| Time: $TimeAndDate | Event: Group Creation Activity | Created Group: $CreatedGroup |"

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

# print out the group deletion
if ($groudel_Count -ge 1) {

  if ($TypeFlag -match "All" -or $TypeFlag -match "Raw") {  

  Write-Output ""
  Write-Output "Group Deletion Activity - Raw Events"

  # variable to cretae the amount of spaces needed for the table
  $MaxLength = ($UsersGroupActivity_HT["groudel"] | Measure-Object Length -Maximum).Maximum

  # variable to stor the new amount of hyfens
  $Border = '-' * $MaxLength

  # foreach loop to iterate and past each event seperate from the hashtable
  foreach ($Event in $UsersGroupActivity_HT["groudel"]) {

    # add space to the right of each event iteration
    $Event = $Event.PadRight($MaxLength)

    # print start\middle border
    Write-Output "+$Border+"

    # print each event
    Write-Output "|$Event|"

  }

  # print last border
  Write-Output "+$Border+"
  }

  if ($TypeFlag -match "All" -or $TypeFlag -match "Statistics") {

  # Initialize variables to store maximum lengths
  $MaxChar_TimeAndDate = 0
  $MaxChar_DeletedGroup = 0

  # foreach loop to iterate and past each event separate from the hashtable
  foreach ($Event in $UsersGroupActivity_HT["groudel"]) {

    # creating variable for the timestamp
    $TimeAndDate = $Event -replace " $Hostname.*",""
    # creating a variable for the deleted group
    $RemoveStart = $Event -replace ".*group \'",""
    $DeletedGroup = $RemoveStart -replace "\' removed.*",""

    # Update max lengths if necessary
    $MaxChar_TimeAndDate = [math]::Max($MaxChar_TimeAndDate,$TimeAndDate.Length)
    $MaxChar_DeletedGroup = [math]::Max($MaxChar_DeletedGroup,$DeletedGroup.Length)
  }


  if ($TypeFlag -match "All") {
  # Strings for the top title of the Statistics Table
  Write-Output "|"
  Write-Output "V"
  Write-Output "Group Deletion Activity - Statistics Table"
  }
  elseif ($TypeFlag -match "Statistics") {
  Write-Output ""
  Write-Output "Group Deletion Activity - Statistics Table"
  }

  # flag to stop $Border iteration after first iteration
  $Flag = "Enable"

  # foreach loop to iterate and past each event separate from the hashtable
  foreach ($Event in $UsersGroupActivity_HT["groudel"]) {

    # creating variable for the timestamp
    $TimeAndDate = $Event -replace " $Hostname.*",""
    # creating a variable for the deleted group
    $RemoveStart = $Event -replace ".*group \'",""
    $DeletedGroup = $RemoveStart -replace "\' removed.*",""

    $TimeAndDate = $TimeAndDate.PadRight($MaxChar_TimeAndDate)
    $DeletedGroup = $DeletedGroup.PadRight($MaxChar_DeletedGroup)

    # Output the result for the current event
    $Result = Write-Output "| Time: $TimeAndDate | Event: Group Deletion Activity | Deleted Group: $DeletedGroup |"

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

# print out the add user to group activity
if ($AddUserToGroup_Count -ge 1) {

  if ($TypeFlag -match "All" -or $TypeFlag -match "Raw") {  

  Write-Output ""
  Write-Output "User Added To A Group Activity - Raw Events"

  # variable to cretae the amount of spaces needed for the table
  $MaxLength = ($UsersGroupActivity_HT["AddUserToGroup"] | Measure-Object Length -Maximum).Maximum

  # variable to stor the new amount of hyfens
  $Border = '-' * $MaxLength

  # foreach loop to iterate and past each event seperate from the hashtable
  foreach ($Event in $UsersGroupActivity_HT["AddUserToGroup"]) {

    # add space to the right of each event iteration
    $Event = $Event.PadRight($MaxLength)

    # print start\middle border
    Write-Output "+$Border+"

    # print each event
    Write-Output "|$Event|"

  }

  # print last border
  Write-Output "+$Border+"

  }

  if ($TypeFlag -match "All" -or $TypeFlag -match "Statistics") {

  # Initialize variables to store maximum lengths
  $MaxChar_TimeAndDate = 0
  $MaxChar_AddedUser = 0
  $MaxChar_ToGroup = 0

  # foreach loop to iterate and past each event separate from the hashtable
  foreach ($Event in $UsersGroupActivity_HT["AddUserToGroup"]) {

    # creating variable for the timestamp
    $TimeAndDate = $Event -replace " $Hostname.*",""
    # creating a variable for the added user name
    $RemoveStart = $Event -replace ".*add \'",""
    $AddedUser = $RemoveStart -replace "\' to group.*",""
    # creating a variable for the group in which the user added to
    $RemoveStart = $Event -replace ".*to group \'",""
    $ToGroup = $RemoveStart -replace "\'",""

    # Update max lengths if necessary
    $MaxChar_TimeAndDate = [math]::Max($MaxChar_TimeAndDate,$TimeAndDate.Length)
    $MaxChar_AddedUser = [math]::Max($MaxChar_AddedUser,$AddedUser.Length)
    $MaxChar_ToGroup = [math]::Max($MaxChar_ToGroup,$ToGroup.Length)
  }

  # Strings for the top title of the Statistics Table
  if ($TypeFlag -match "All") {
  Write-Output "|"
  Write-Output "V"
  Write-Output "User Added To A Group Activity - Statistics Table"
  }

  elseif ($TypeFlag -match "Statistics"){
  Write-Output ""
  Write-Output "User Added To A Group Activity - Statistics Table"
  }

  # flag to stop $Border iteration after first iteration
  $Flag = "Enable"

  # foreach loop to iterate and past each event separate from the hashtable
  foreach ($Event in $UsersGroupActivity_HT["AddUserToGroup"]) {

    # creating variable for the timestamp
    $TimeAndDate = $Event -replace " $Hostname.*",""
    # creating a variable for the added user name
    $RemoveStart = $Event -replace ".*add \'",""
    $AddedUser = $RemoveStart -replace "\' to group.*",""
    # creating a variable for the group in which the user added to
    $RemoveStart = $Event -replace ".*to group \'",""
    $ToGroup = $RemoveStart -replace "\'",""

    $TimeAndDate = $TimeAndDate.PadRight($MaxChar_TimeAndDate)
    $AddedUser = $AddedUser.PadRight($MaxChar_AddedUser)
    $ToGroup = $ToGroup.PadRight($MaxChar_ToGroup)

    # Output the result for the current event
    $Result = Write-Output "| Time: $TimeAndDate | Event: User Added To A Group | The User: $AddedUser | To Group: $ToGroup |"

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

# print out the remove user from group activity
if ($RemoveUserFromGroup_Count -ge 1) {
  
  if ($TypeFlag -match "All" -or $TypeFlag -match "Raw") {
    
  Write-Output ""
  Write-Output "User Removed From A Group Activity - Raw Events"

  # variable to cretae the amount of spaces needed for the table
  $MaxLength = ($UsersGroupActivity_HT["RemoveUserFromGroup"] | Measure-Object Length -Maximum).Maximum

  # variable to stor the new amount of hyfens
  $Border = '-' * $MaxLength

  # foreach loop to iterate and past each event seperate from the hashtable
  foreach ($Event in $UsersGroupActivity_HT["RemoveUserFromGroup"]) {

    # add space to the right of each event iteration
    $Event = $Event.PadRight($MaxLength)

    # print start\middle border
    Write-Output "+$Border+"

    # print each event
    Write-Output "|$Event|"

  }

  # print last border
  Write-Output "+$Border+"

  }

  if ($TypeFlag -match "All" -or $TypeFlag -match "Statistics") {

  # Initialize variables to store maximum lengths
  $MaxChar_TimeAndDate = 0
  $MaxChar_RemovedUser = 0
  $MaxChar_RemovedBy = 0
  $MaxChar_FromGroup = 0

  # foreach loop to iterate and past each event separate from the hashtable
  foreach ($Event in $UsersGroupActivity_HT["RemoveUserFromGroup"]) {

    # creating variable for the timestamp
    $TimeAndDate = $Event -replace " $Hostname.*",""
    # creating a variable for the removed user name
    $RemoveStart = $Event -replace '.*\: user ',''
    $RemovedUser = $RemoveStart -replace ' removed by.*',''
    # creating a variable for the removed by user name
    $RemoveStart = $Event -replace '.*removed by ',''
    $RemovedBy = $RemoveStart -replace ' from group.*',''
    # creating a variable for the group in which the user removed from
    $FromGroup = $Event -replace '.*from group ',''

    # Update max lengths if necessary
    $MaxChar_TimeAndDate = [math]::Max($MaxChar_TimeAndDate,$TimeAndDate.Length)
    $MaxChar_RemovedUser = [math]::Max($MaxChar_RemovedUser,$RemovedUser.Length)
    $MaxChar_RemovedBy = [math]::Max($MaxChar_RemovedBy,$RemovedBy.Length)
    $MaxChar_FromGroup = [math]::Max($MaxChar_FromGroup,$FromGroup.Length)
  }

  if ($TypeFlag -match "All") {
  Write-Output "|"
  Write-Output "V"
  Write-Output "User Removed From A Group Activity - Statistics Table"
  }

  elseif ($TypeFlag -match "Statistics") {
  Write-Output ""
  Write-Output "User Removed From A Group Activity - Statistics Table"
  }

  # flag to stop $Border iteration after first iteration
  $Flag = "Enable"

  # foreach loop to iterate and past each event separate from the hashtable
  foreach ($Event in $UsersGroupActivity_HT["RemoveUserFromGroup"]) {

    # creating variable for the timestamp
    $TimeAndDate = $Event -replace " $Hostname.*",""
    # creating a variable for the removed user name
    $RemoveStart = $Event -replace '.*\: user ',''
    $RemovedUser = $RemoveStart -replace ' removed by.*',''
    # creating a variable for the removed by user name
    $RemoveStart = $Event -replace '.*removed by ',''
    $RemovedBy = $RemoveStart -replace ' from group.*',''
    # creating a variable for the group in which the user removed from
    $FromGroup = $Event -replace '.*from group ',''

    $TimeAndDate = $TimeAndDate.PadRight($MaxChar_TimeAndDate)
    $RemovedUser = $RemovedUser.PadRight($MaxChar_RemovedUser)
    $RemovedBy = $RemovedBy.PadRight($MaxChar_RemovedBy)
    $FromGroup = $FromGroup.PadRight($MaxChar_FromGroup)

    # Output the result for the current event
    $Result = Write-Output "| Time: $TimeAndDate | Event: User Removed From Group | The User: $RemovedUser | Removed By: $RemovedBy | From Group: $FromGroup |"

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

# print out the user information change
if ($UserInformationChange_Count -ge 1) {

  if ($TypeFlag -match "All" -or $TypeFlag -match "Raw") {

  Write-Output ""
  Write-Output "User Information Change - Raw Events"

  # variable to cretae the amount of spaces needed for the table
  $MaxLength = ($UsersGroupActivity_HT["UserInformationChange"] | Measure-Object Length -Maximum).Maximum

  # variable to stor the new amount of hyfens
  $Border = '-' * $MaxLength

  # foreach loop to iterate and past each event seperate from the hashtable
  foreach ($Event in $UsersGroupActivity_HT["UserInformationChange"]) {

    # add space to the right of each event iteration
    $Event = $Event.PadRight($MaxLength)

    # print start\middle border
    Write-Output "+$Border+"

    # print each event
    Write-Output "|$Event|"

  }

  # print last border
  Write-Output "+$Border+"
  
  }

   if ($TypeFlag -match "All" -or $TypeFlag -match "Statistics") {

  # hashtable
  $UserInformationChange = @{}

  # foreach loop to iterate and past each event seperate from the hashtable
  foreach ($Event in $UsersGroupActivity_HT["UserInformationChange"]) {

    # Getting the user name
    $RemoveStart = $Event -replace ".*changed user '",""
    $UserName = $RemoveStart -replace "' information.*",""

    # check if $UserInformationChange hashtable contains $UserName key in it
    if ($UserInformationChange.ContainsKey($UserName)) {

      # if key is contained increment the value of the key $UserName
      $UserInformationChange[$UserName]++
    }

    # if the $UserInformationChange is not containing the $UserName key in it
    else {

      # assign the integer "1" to the value of the key $UserName
      $UserInformationChange[$UserName] = 1
    }
  }

  if ($TypeFlag -match "All") {
  Write-Output "|"
  Write-Output "V"
  Write-Output "User Information Change - Statistics Table"
  }
  
  elseif ($TypeFlag -match "Statistics") {
  Write-Output ""
  Write-Output "User Information Change - Statistics Table"
  }

  # Find max lengths for the keys and the values of the hashtable
  $MaxCharKey = ($UserInformationChange.Keys | Measure-Object Length -Maximum).Maximum
  $MaxCharValue = ($UserInformationChange.Values | Measure-Object -Maximum).Maximum.ToString().Length

  # flag to stop $Border iteration after first iteration
  $Flag = "Enable"

  # iterate through all the keys in the hashtable in a foreach loop
  foreach ($Key in $UserInformationChange.Keys) {

    # add the needed spaces for the keys and values of the hashtbale
    $SpacedKey = $Key.PadRight($MaxCharKey)
    $SpacedValue = $UserInformationChange[$Key].ToString().PadRight($MaxCharValue)

    # how you want the result to print out
    $Final = "| Event: User Information Changed | User: $SpacedKey | Change Count: $SpacedValue |"

    # calculate border
    $Border = '-' * ($Final.Length - 2)

    # Print the boarder once
    if ($Flag -match "Enable") {
    Write-Output "+$Border+"
    $Flag = "Disable"
    }

    Write-Output "$Final"

  }
  # last board print outside of the foreach loop
  Write-Output "+$Border+"
  }
}

# reset variables
$useradd_Count = $null
$userdel_Count = $null
$ChangePassword_Count = $null
$groupadd_Count = $null
$groudel_Count = $null
$AddUserToGroup_Count = $null
$RemoveUserFromGroup_Count = $null
$UserInformationChange_Count = $null
