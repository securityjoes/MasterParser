if ($main["user_login"].Count -ge 1 -and $main["user_logout"].Count -ge 1) {

  # login hashtable
  $login_hashtable = @{}
  foreach ($event in $main["user_login"]) {
    $session_id = $event -replace '.*New session ','' -replace ' of user.*',''
    $login_hashtable[$session_id] += $event
  }

  # logout hashtable
  $logout_hashtable = @{}
  foreach ($event in $main["user_logout"]) {
    $session_id = $event -replace '.*Removed session ','' -replace '\.',''
    $logout_hashtable[$session_id] += $event
  }

  # lists
  $username_list = @()
  $login_session_id_list = @()
  $start_time_list = @()
  $end_time_list = @()
  $duration_calc_login_list = @()

  # code logic - is there a session number maching ?
  foreach ($login_session_id in $login_hashtable.Keys) {
    $matchFound = $false

    foreach ($logout_session_id in $logout_hashtable.Keys) {
      if ($login_session_id -eq $logout_session_id) {
        $matchFound = $true
        $login_log = $login_hashtable[$login_session_id]
        $logout_log = $logout_hashtable[$logout_session_id]
        $username = $login_log -replace '.*New session.*of user ','' -replace '\.',''
        $username_list += $username
        $login_session_id_list += $login_session_id
        $start_time = $login_log -replace " $hostname.*",""
        $start_time_list += $start_time
        $end_time = $logout_log -replace " $hostname.*",""
        $end_time_list += $end_time
        $duration_calc_login = duration_calc -start_time $start_time -end_time $end_time
        $duration_calc_login_list += $duration_calc_login

      }
    }
  }

  $usr_max_char = ($username_list | Measure-Object -Maximum -Property Length).Maximum
  $sid_max_char = ($login_session_id_list | Measure-Object -Maximum -Property Length).Maximum
  $sta_max_char = ($start_time_list | Measure-Object -Maximum -Property Length).Maximum
  $end_max_char = ($end_time_list | Measure-Object -Maximum -Property Length).Maximum
  $dur_max_char = ($duration_calc_login_list | Measure-Object -Maximum -Property Length).Maximum

  # code logic - is there a session number maching ?
  foreach ($login_session_id in $login_hashtable.Keys) {
    $matchFound = $false

    foreach ($logout_session_id in $logout_hashtable.Keys) {
      if ($login_session_id -eq $logout_session_id) {
        $matchFound = $true
        $login_log = $login_hashtable[$login_session_id]
        $logout_log = $logout_hashtable[$logout_session_id]
        $username = $login_log -replace '.*New session.*of user ','' -replace '\.',''
        $start_time = $login_log -replace " $hostname.*",""
        $end_time = $logout_log -replace " $hostname.*",""
        $duration_calc_login = duration_calc -start_time $start_time -end_time $end_time
        $main["system_logins_calc"] += Write-Output " Username: $($username.PadRight($usr_max_char)) | Session ID: $($login_session_id.PadRight($sid_max_char)) | Login Time: $($start_time.PadRight($sta_max_char)) | Logout Time: $($end_time.PadRight($end_max_char)) | Login Duration: $($duration_calc_login.PadRight($dur_max_char)) "
      }
    }
  }
}
