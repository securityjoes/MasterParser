if ($main["successful_ssh"].Count -ge 1 -or $main["successful_publickey_ssh"].Count -ge 1 -and $main["ssh_disconnections_postauth"].Count -ge 1) {
    
    # ssh_login hashtable creation
    $ssh_login = @{}

    # successful_publickey_ssh
    foreach ($event in $main["successful_publickey_ssh"]) {
        $source_port = $event -replace '.*from.*port ','' -replace ' .*',''
        $ssh_login[$source_port] += $event     
    }

    # successful_ssh
    foreach ($event in $main["successful_ssh"]) {
        $source_port = $event -replace '.*from.*port ','' -replace ' .*',''
        $ssh_login[$source_port] += $event
    }

    # disconnections_ssh_hashtbale
    $ssh_logout = @{}
    foreach ($event in $main["ssh_disconnections_postauth"]) {
        $source_port = $event -replace '.*from.*port ','' -replace '( .*|\:.*)',''
        $ssh_logout[$source_port] += $event
    }

    # lists
    $username_list = @()
    $source_port_list = @()
    $ip_list = @()
    $start_time_list = @()
    $end_time_list = @()
    $duration_calc_login_list = @()
    

    # code logic - matching login logout source ports
    foreach ($login_source_port in $ssh_login.Keys) {
        # flag
        $matchFound = $false

        foreach ($logout_source_port in $ssh_logout.Keys) {
            if ($login_source_port -eq $logout_source_port) {

                # flag
                $matchFound = $true
            
                # create login\logout log lines
                $ssh_login_log = $ssh_login[$login_source_port]
                $ssh_logout_log = $ssh_logout[$logout_source_port]
            
                # username
                $username = $ssh_login_log -replace '.*Accepted.*for ','' -replace ' from.*port.*',''
                $username_list += $username
                # source port
                $source_port_list += $login_source_port
                # ip
                $ip = $ssh_login_log -replace '.*for.*from ','' -replace ' port.*',''
                $ip_list += $ip
                # start time
                $start_time = $ssh_login_log -replace " $hostname.*",""
                $start_time_list += $start_time
                # end time
                $end_time = $ssh_logout_log -replace " $hostname.*",""
                $end_time_list += $end_time
                # duration
                $duration_calc_login = duration_calc -start_time $start_time -end_time $end_time
                $duration_calc_login_list += $duration_calc_login
            }
        }
        
        if (-not $matchFound) {
            # create login\logout log lines
            $ssh_login_log = $ssh_login[$login_source_port]
            $ssh_logout_log = $ssh_logout[$logout_source_port]
            
            # username
            $username = $ssh_login_log -replace '.*Accepted.*for ','' -replace ' from.*port.*',''
            $username_list += $username
            # source port
            $source_port_list += $login_source_port
            # ip
            $ip = $ssh_login_log -replace '.*for.*from ','' -replace ' port.*',''
            $ip_list += $ip
            # start time
            $start_time = $ssh_login_log -replace " $hostname.*",""
            $start_time_list += $start_time

            }
    }

    # calc char max size from lists 
    $usr_max_char = ($username_list | Measure-Object -Maximum -Property Length).Maximum
    $lsp_max_char = ($source_port_list | Measure-Object -Maximum -Property Length).Maximum
    $lip_max_char = ($ip_list | Measure-Object -Maximum -Property Length).Maximum
    $sta_max_char = ($start_time_list | Measure-Object -Maximum -Property Length).Maximum
    $end_max_char = ($end_time_list | Measure-Object -Maximum -Property Length).Maximum
    $dur_max_char = ($duration_calc_login_list | Measure-Object -Maximum -Property Length).Maximum
    

    foreach ($login_source_port in $ssh_login.Keys) {
        # flag
        $matchFound = $false

        foreach ($logout_source_port in $ssh_logout.Keys) {
            if ($login_source_port -eq $logout_source_port) {
            # flag
            $matchFound = $true
            
            # create login\logout log lines
            $ssh_login_log = $ssh_login[$login_source_port]
            $ssh_logout_log = $ssh_logout[$logout_source_port]

            # username
            $username = $ssh_login_log -replace '.*Accepted.*for ','' -replace ' from.*port.*',''
            # source port
            $source_port_list += $login_source_port
            # ip
            $ip = $ssh_login_log -replace '.*for.*from ','' -replace ' port.*',''
            # start time
            $start_time = $ssh_login_log -replace " $hostname.*",""
            # end time
            $end_time = $ssh_logout_log -replace " $hostname.*",""
            # duration
            $duration_calc_login = duration_calc -start_time $start_time -end_time $end_time
            
            # output
            $main["ssh_logins_calc"] += Write-Output " Username: $($username.PadRight($usr_max_char)) | Port: $($login_source_port.PadRight($lsp_max_char)) | IP: $($ip.PadRight($lip_max_char)) | Login Time: $($start_time.PadRight($sta_max_char)) | Logout Time: $($end_time.PadRight($end_max_char)) | Login Duration: $($duration_calc_login.PadRight($dur_max_char)) "
            }
        }

        if (-not $matchFound) {
            # create login\logout log lines
            $ssh_login_log = $ssh_login[$login_source_port]
            $ssh_logout_log = $ssh_logout[$logout_source_port]
            
            # username
            $username = $ssh_login_log -replace '.*Accepted.*for ','' -replace ' from.*port.*',''
            $username_list += $username
            # source port
            $source_port_list += $login_source_port
            # ip
            $ip = $ssh_login_log -replace '.*for.*from ','' -replace ' port.*',''
            $ip_list += $ip
            # start time
            $start_time = $ssh_login_log -replace " $hostname.*",""
            $start_time_list += $start_time

            # output
            $main["ssh_logins_calc"] += Write-Output " Username: $($username.PadRight($usr_max_char)) | Port: $($login_source_port.PadRight($lsp_max_char)) | IP: $($ip.PadRight($lip_max_char)) | Login Time: $($start_time.PadRight($sta_max_char)) | Logout Time: $("N/A".PadRight($end_max_char)) | Login Duration: $("N/A".PadRight($dur_max_char)) "
            }
    }

}