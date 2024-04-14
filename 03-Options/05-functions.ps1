# calculate run time function
#region
function start_time {
    return Get-Date
}

function stop_time {
    param (
        [datetime]$start_time
    )

    $stop_time = Get-Date
    $time_taken = $stop_time - $start_time
    return '{0:00}:{1:00}:{2:00}' -f $time_taken.Hours, $time_taken.Minutes, $time_taken.Seconds
    
    # How to Run This Function ?
    # at the beginning of the script block you want to masure

    # put this argument 
    #"$name_of_what_you_want_to_measure = start_time"

    # and at the end of this script block put this argument 
    # "$this_is_the_run_time = stop_time -start_time $name_of_what_you_want_to_measure"

}
#endregion

# calculate duration from start_time and end_time
#region
function duration_calc {
    param (
    [string]$start_time,
    [string]$end_time
    )
    
    $start_time = $start_time -replace '  ',' '
    $end_time = $end_time -replace '  ',' '

    $start_time_split = $start_time -split " "
    $end_time_split = $end_time -split " " 

    if ($start_time_split[1].Length -eq 1) {
    $StartTimeConverted = [datetime]::ParseExact($start_time,'MMM d HH:mm:ss',$null)
    }
    elseif ($start_time_split[1].Length -eq 2) {
        $StartTimeConverted = [datetime]::ParseExact($start_time,'MMM dd HH:mm:ss',$null)
    }

    if ($end_time_split[1].Length -eq 1) {
        $EndTimeConverted = [datetime]::ParseExact($end_time,'MMM d HH:mm:ss',$null)
    }
    elseif ($end_time_split[1].Length -eq 2) {
        $EndTimeConverted = [datetime]::ParseExact($end_time,'MMM dd HH:mm:ss',$null)
    }

    $Duration = $EndTimeConverted - $StartTimeConverted
    $full_duration = Write-Output "$($Duration.Days) Days $($Duration.Hours) Hours $($Duration.Minutes) Minutes $($Duration.Seconds) Seconds"
    return $full_duration
}
#endregion