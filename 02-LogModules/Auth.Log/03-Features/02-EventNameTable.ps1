# Hashtable to store the 5th word
$5th_word_table = @{}

# Regular expression pattern to match the fifth word
$pattern = '\S+\s+\S+\s+\S+\s+\S+\s+(\S+)'

# Get the content of the file directly using switch statement
switch -Regex -File "$RunningPath\02-LogModules\Auth.Log\01-LogCopy\Auth.Log.Parser.Copy.txt" {
    $pattern {
        $5th_word = $matches[1] -replace '\[|[0-9]{1,15}|\]|\:',''

        if ($5th_word_table.ContainsKey($5th_word)) {
            $5th_word_table[$5th_word]++
        } else {
            $5th_word_table[$5th_word] = 1
        }
    }
}

# Transform the hashtable into an array of custom objects for easier formatting
$5th_word_table_Fixed = $5th_word_table.GetEnumerator() | Sort-Object Value -Descending | ForEach-Object {
    [pscustomobject]@{
        "Event Name" = $_.Key
        "Count"      = $_.Value
    }
}

# Output the result
Write-Output ""
$5th_word_table_Fixed | Format-Table -Property "Event Name", "Count" | Out-String -Width 50 | ForEach-Object { $_.Trim() }
