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

    # Variable to find a pattern of password change action using "passwd".
    $ChangePassword = $SingleLine | Select-String -Pattern ".*passwd\[[0-9]{0,15}\]\: .* password changed for.*"

    # Variable to find a pattern of password change action using "usermod".
    $ChangePassword = $SingleLine | Select-String -Pattern ".*usermod\[[0-9]{0,15}\]\: change user.*"
    
    # Variable to find a pattern of password change action using "chpasswd".
    $ChangePassword = $SingleLine | Select-String -Pattern ".*chpasswd\[[0-9]{0,15}\]\:.*password changed for.*"
    
    # Check if the line matches the first pattern
    if ($ChangePassword) {
        # Save the line to the array in the hashtable
        $UsersGroupActivity_HT["ChangePassword"] += $ChangePassword.Line
        $ChangePassword_Count = $UsersGroupActivity_HT["ChangePassword"].Count
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

    # Variable to find a pattern of seesion opend for root.
    $RootSession = $SingleLine | Select-String -Pattern ".*sudo\: pam_unix\(sudo\:session\)\: session opened for user root by.*"

    # Check if the line matches the first pattern
    if ($RootSession) {
        # Save the line to the array in the hashtable
        $UsersGroupActivity_HT["RootSession"] += $RootSession.Line
        $RootSession_Count = $UsersGroupActivity_HT["RootSession"].Count
    }

}

# print out the user creation activity
if ($useradd_Count -ge 1) {
Write-Output ""
Write-Output "New User Creation Activity"
Write-Output "+------------------------+"
$UsersGroupActivity_HT["useradd"]
}

else {
$NotFoundHashTable['NoNewUserCreation'] = "[*] Not Found: User Creation Activity."
}

# print out the user deletion activity
if ($userdel_Count -ge 1) {
Write-Output ""
Write-Output "User Deletion Activity"
Write-Output "+--------------------+"
$UsersGroupActivity_HT["userdel"]
}

else {
$NotFoundHashTable['NoUserDeletion'] = "[*] Not Found: User Deletion Activity."
}

# print out the user creation
if ($ChangePassword_Count -ge 1) {
Write-Output ""
Write-Output "User Password Change Activity"
Write-Output "+---------------------------+"
$UsersGroupActivity_HT["ChangePassword"]
}

else {
$NotFoundHashTable['NoPasswordChange'] = "[*] Not Found: User Password Change Activity."
}

# print out the group creation
if ($groupadd_Count -ge 1) {
Write-Output ""
Write-Output "New Group Creation Activity"
Write-Output "+-------------------------+"
$UsersGroupActivity_HT["groupadd"]
}

else {
$NotFoundHashTable['NoNewGroupCreation'] = "[*] Not Found: Group Creation Activity."
}

# print out the group deletion
if ($groudel_Count -ge 1) {
Write-Output ""
Write-Output "Group Deletion Activity"
Write-Output "+---------------------+"
$UsersGroupActivity_HT["groudel"]
}

else {
$NotFoundHashTable['NoGroupDeletion'] = "[*] Not Found: Group Deletion Activity."
}

# print out the add user to group activity
if ($AddUserToGroup_Count -ge 1) {
Write-Output ""
Write-Output "User Added To A Group Activity"
Write-Output "+----------------------------+"
$UsersGroupActivity_HT["AddUserToGroup"]
}

else {
$NotFoundHashTable['NoAddUserToGroup'] = "[*] Not Found: User Added To A Group Activity."
}

# print out the remove user from group activity
if ($RemoveUserFromGroup_Count -ge 1) {
Write-Output ""
Write-Output "User Removed From A Group Activity"
Write-Output "+--------------------------------+"
$UsersGroupActivity_HT["RemoveUserFromGroup"]
}

else {
$NotFoundHashTable['NoRemoveUserFromGroup'] = "[*] Not Found: User Removed From A Group Activity."
}

# print out the remove user from group activity
if ($RootSession_Count -ge 1) {
Write-Output ""
Write-Output "Session Opened For User root "
Write-Output "+---------------------------+"
$UsersGroupActivity_HT["RootSession"]
}

else {
$NotFoundHashTable['NoRootSession'] = "[*] Not Found: Session Opened For User root."
}

# reset
$useradd_Count = $null
$userdel_Count = $null
$ChangePassword_Count = $null
$groupadd_Count = $null
$groudel_Count = $null
$AddUserToGroup_Count = $null
$RemoveUserFromGroup_Count = $null
$RootSession_Count = $null
