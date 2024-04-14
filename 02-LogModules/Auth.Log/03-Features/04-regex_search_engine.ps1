# start time
if ($Mode -eq "Developer") {
$regex_search_engine_start_time = start_time
}

# regex search engine
#region

# read the content of the log file
$log_content = Get-Content -Path $AuthLogCopyLocation

# main hashtable
$main = @{
    "successful_ssh" = @()
    "successful_publickey_ssh" = @()
    "ssh_disconnections_postauth" = @()
    "valid_users_failed_ssh" = @()
    "invalid_users_failed_ssh" = @()
    "ssh_maxstartups" = @()
    "user_login" = @()
    "user_logout" = @()
    "user_creation" = @()
    "user_deletion" = @()
    "password_change" = @()
    "group_creation" = @()
    "group_deletion" = @()
    "user_add_to_group" = @()
    "user_removed_from_group" = @()
    "user_information_changed" = @()
    "root_session_opened" = @()
    "root_session_closed" = @()
    "elevated_commands_executions" = @()
    "no_sudo_permission" = @()
    "ftp" = @()
    
    # outsource lists
    "system_logins_calc" = @()
    "ssh_logins_calc" = @()
}

# main patterns list
$patterns = @(
    
    #ssh
    @(
    "sshd.*Accepted password for",
    "sshd.*Accepted publickey for",
    "sshd.*Failed password for(?!.*invalid)",
    "sshd.*Failed password for invalid user"
    "sshd.*Received disconnect.*port(?!.*\[preauth\])",
    "sshd.*MaxStartups"
    ),
    
    #ftp
    @(
    "vsftpd.*authentication failure"
    ),
    
    #users groups
    @(
    "useradd.*new user\: name\=",
    "userdel.*delete user",
    "groupadd.*new group\: name\=",
    "groupdel.*group.*removed",
    "usermod.*add.*to group",
    "gpasswd.*user.*removed by",
    "chfn.*changed user.*information"
    ),

    #user system logins
    @(
    "systemd-logind.*New session.*of user",               
    "systemd-logind.*Removed session"
    ),

    #passwords
    @(
    "passwd.*\(passwd.*password changed for",
    "usermod.*change user",
    "chpasswd.*\(chpasswd.*password changed for"
    ),
    
    #elevated activity
    @(
    "su\:.*session opened for user",
    "su.*su:session.*session closed for user",
    "(sudo|su)\:.*COMMAND\=",
    "user NOT in sudoers.*COMMAND"
    )
)

# Flatten the $patterns array
$flattenedPatterns = $patterns | ForEach-Object { $_ }

# Dynamically construct the combined pattern
$combined_pattern = [regex]::new("(" + ($flattenedPatterns -join "|") + ")")

# Loop through each line and match against the combined pattern
foreach ($line in $log_content) {
    if ($combined_pattern.IsMatch($line)) {
        $matchedText = $combined_pattern.Match($line).Value
        switch -Regex ($matchedText) { 
            
            #ssh
            $patterns[0][0] { $main["successful_ssh"]               += $line }
            $patterns[0][1] { $main["successful_publickey_ssh"]     += $line }
            $patterns[0][2] { $main["valid_users_failed_ssh"]       += $line }
            $patterns[0][3] { $main["invalid_users_failed_ssh"]     += $line }
            $patterns[0][4] { $main["ssh_disconnections_postauth"]  += $line }
            $patterns[0][5] { $main["ssh_maxstartups"]              += $line }
            
            #ftp
            $patterns[1][0] { $main["ftp"]                          += $line }

            #users_groups
            $patterns[2][0] { $main["user_creation"]                += $line }
            $patterns[2][1] { $main["user_deletion"]                += $line }
            $patterns[2][2] { $main["group_creation"]               += $line }
            $patterns[2][3] { $main["group_deletion"]               += $line }
            $patterns[2][4] { $main["user_add_to_group"]            += $line }
            $patterns[2][5] { $main["user_removed_from_group"]      += $line }
            $patterns[2][6] { $main["user_information_changed"]     += $line }
            
            #user_system_logins
            $patterns[3][0] { $main["user_login"]                   += $line }
            $patterns[3][1] { $main["user_logout"]                  += $line }

            #passwords
            $patterns[4][0]  { $main["password_change"]             += $line }
            $patterns[4][1]  { $main["password_change"]             += $line }
            $patterns[4][2]  { $main["password_change"]             += $line }

            #elevated_activity
            $patterns[5][0] { $main["root_session_opened"]          += $line }
            $patterns[5][1] { $main["root_session_closed"]          += $line }
            $patterns[5][2] { $main["elevated_commands_executions"] += $line }
            $patterns[5][3] { $main["no_sudo_permission"]           += $line }

        }
    }
}

#endregion

# run time
if ($Mode -eq "Developer") {
$regex_search_engine_run_time = stop_time -start_time $regex_search_engine_start_time
Write-Output ""
Write-Output "regex_search_engine_run_time: $regex_search_engine_run_time"
}