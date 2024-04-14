# start time
#region

if ($Mode -eq "Developer") {
$formatting_function_start_time = start_time
}

#endregion

# final_output
#region

function final_output {
    param (
        [string]$check_count,
        [string]$title_name,
        [string]$title_side = " - Raw Logs",
        [string]$key_name,
        [bool]$run_once = $false,
        [bool]$top_space = $true,
        [string]$add_color = "DarkGreen",
        [string]$add_string_0 = $null,
        [string]$add_string_1 = $null,
        [string]$add_string_2 = $null,
        [string]$add_string_3 = $null,
        [string]$add_string_4 = $null
    )

    if ($check_count -ge 1) {
            if ($top_space -eq $true) {
                Write-Host ""
            }
            Write-Host "$add_string_0$title_name$title_side" -ForegroundColor $add_color
            $MaxLength = ($main[$key_name] | Measure-Object Length -Maximum).Maximum
            $Border = '-' * $MaxLength
            if ($run_once -eq $true) {
                Write-Host "$add_string_1+$Border+"
            }
            foreach ($Event in $main[$key_name]) {
                $Event = $Event.PadRight($MaxLength)
                if ($run_once -eq $false) {
                    Write-Host "$add_string_2+$Border+"
                }
                Write-Host "$add_string_3|$Event|"
            }
            Write-Host "$add_string_4+$Border+"
    }
}

#endregion

# SSH
#region

# SSH Logins Full Output Statment
#region
# password=1 publickey=1
if ($main["successful_ssh"].Count -ge 1 -and $main["successful_publickey_ssh"].Count -ge 1) {
    final_output -check_count $main["successful_ssh"].Count -title_name "Successful SSH Password Authentication" -key_name "successful_ssh" -add_string_0 "┌>"
    final_output -check_count $main["successful_publickey_ssh"].Count -title_name "Successful SSH Public key Authentication" -key_name "successful_publickey_ssh" -top_space $false -add_string_0 "├>"
    final_output -check_count $main["ssh_disconnections_postauth"].Count -title_name "SSH Disconnections [postauth]" -key_name "ssh_disconnections_postauth" -top_space $false -add_string_0 "└>" -add_string_1 "   " -add_string_2 "   " -add_string_3 "   " -add_string_4 "   "
    final_output -check_count $main["ssh_logins_calc"].Count -title_name "SSH Logins Calculation" -key_name "ssh_logins_calc" -title_side " - Statistics" -run_once $true -top_space $false -add_string_0 "   └->" -add_string_1 "      " -add_string_2 "      " -add_string_3 "      " -add_string_4 "      "
}
# password=1 publickey=0
elseif ($main["successful_ssh"].Count -ge 1 -and $main["successful_publickey_ssh"].Count -eq 0) {
    final_output -check_count $main["successful_ssh"].Count -title_name "Successful SSH Password Authentication" -key_name "successful_ssh"
    final_output -check_count $main["ssh_disconnections_postauth"].Count -title_name "SSH Disconnections [postauth]" -key_name "ssh_disconnections_postauth" -top_space $false -add_string_0 "└->" -add_string_2 "   " -add_string_3 "   " -add_string_4 "   "
    final_output -check_count $main["ssh_logins_calc"].Count -title_name "SSH Logins Calculation" -key_name "ssh_logins_calc"  -title_side " - Statistics" -run_once $true -top_space $false -add_string_0 "   └->" -add_string_1 "      " -add_string_2 "      " -add_string_3 "      " -add_string_4 "      "

}
# password=0 publickey=1
elseif ($main["successful_ssh"].Count -eq 0 -and $main["successful_publickey_ssh"].Count -ge 1) {
    final_output -check_count $main["successful_publickey_ssh"].Count -title_name "Successful SSH Public key Authentication" -key_name "successful_publickey_ssh"
    final_output -check_count $main["ssh_disconnections_postauth"].Count -title_name "SSH Disconnections [postauth]" -key_name "ssh_disconnections_postauth" -top_space $false -add_string_0 "└->" -add_string_2 "   " -add_string_3 "   " -add_string_4 "   "
    final_output -check_count $main["ssh_logins_calc"].Count -title_name "SSH Logins Calculation" -key_name "ssh_logins_calc"  -title_side " - Statistics" -run_once $true -top_space $false -add_string_0 "   └->" -add_string_1 "      " -add_string_2 "      " -add_string_3 "      " -add_string_4 "      "
}
#endregion

# SSH Failed Logins
#region

# valid=1 invalid=1
if ($main["valid_users_failed_ssh"].Count -ge 1 -and $main["invalid_users_failed_ssh"].Count -ge 1) {
    final_output -check_count $main["valid_users_failed_ssh"].Count -title_name "Valid Users Failed SSH Password Authentication" -key_name "valid_users_failed_ssh" -add_string_0 "┌>"
    final_output -check_count $main["invalid_users_failed_ssh"].Count -title_name "Invalid Users Failed SSH Password Authentication" -key_name "invalid_users_failed_ssh" -top_space $false -add_string_0 "├>"
}
# valid=1 invalid=0
elseif ($main["valid_users_failed_ssh"].Count -ge 1 -and $main["invalid_users_failed_ssh"].Count -eq 0) {
    final_output -check_count $main["valid_users_failed_ssh"].Count -title_name "Valid Users Failed SSH Password Authentication" -key_name "valid_users_failed_ssh"
}
# valid=0 invalid=1
elseif ($main["valid_users_failed_ssh"].Count -eq 0 -and $main["invalid_users_failed_ssh"].Count -ge 1) {
    final_output -check_count $main["invalid_users_failed_ssh"].Count -title_name "Invalid Users Failed SSH Password Authentication" -key_name "invalid_users_failed_ssh"
}

# Dot Sourcing -> 07-ssh_brute_force_detector.ps1
. "$RunningPath\02-LogModules\Auth.Log\03-Features\07-ssh_brute_force_detector.ps1"

final_output -check_count $main["ssh_maxstartups"].Count -title_name "SSH MaxStartups" -key_name "ssh_maxstartups"
#endregion

#endregion


# FTP
final_output -check_count $main["ftp"].Count -title_name "FTP Authentication Failure" -key_name "ftp"


# User System Logins
final_output -check_count $main["user_login"].Count -title_name "User System Login" -key_name "user_login"
final_output -check_count $main["user_logout"].Count -title_name "User System Logout" -key_name "user_logout" -top_space $false -add_string_0 "└->" -add_string_2 "   " -add_string_3 "   " -add_string_4 "   "
final_output -check_count $main["system_logins_calc"].Count -title_name "User System Logins Calculation" -key_name "system_logins_calc" -title_side " - Statistics" -run_once $true -top_space $false -add_string_0 "   └->" -add_string_1 "      " -add_string_2 "      " -add_string_3 "      " -add_string_4 "      "


# Users Groups Activity
final_output -check_count $main["user_creation"].Count -title_name "User Creation" -key_name "user_creation"
final_output -check_count $main["user_deletion"].Count -title_name "User Deletion" -key_name "user_deletion"
final_output -check_count $main["group_creation"].Count -title_name "Group Creation" -key_name "group_creation"
final_output -check_count $main["group_deletion"].Count -title_name "Group Deletion" -key_name "group_deletion"
final_output -check_count $main["user_add_to_group"].Count -title_name "User Added To A Group" -key_name "user_add_to_group"
final_output -check_count $main["user_removed_from_group"].Count -title_name "User Removed From A Group" -key_name "user_removed_from_group"
final_output -check_count $main["user_information_changed"].Count -title_name "User Information Change" -key_name "user_information_changed"


# Passwords
final_output -check_count $main["password_change"].Count -title_name "User Password Change" -key_name "password_change"


# Elevated User Activity
final_output -check_count $main["root_session_opened"].Count -title_name "Elevated Session Opened For User Root" -key_name "root_session_opened"
final_output -check_count $main["root_session_closed"].Count -title_name "Elevated Session Closed For User Root" -key_name "root_session_closed"
final_output -check_count $main["elevated_commands_executions"].Count -title_name "Elevated Commands Executions" -key_name "elevated_commands_executions"
final_output -check_count $main["no_sudo_permission"].Count -title_name "No Permission To Use sudo" -key_name "no_sudo_permission"


# run time
#region

if ($Mode -eq "Developer") {
$formatting_function_run_time = stop_time -start_time $formatting_function_start_time
$formatting_function_run_time
}

#endregion