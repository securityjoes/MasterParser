# hashtable to store the 5th word
$5th_word_table = @{}

# variable to get auth.log copy content.
$AuthLogCopyContent = Get-Content $AuthLogCopyLocation

# foreach loop to iterate through lines of the auth.log file.
foreach ($SingleLine in $AuthLogCopyContent) {

  # Split each line into words
  $Words = $SingleLine -split ' '

  # variable to remove irrelevant characters from the 5th word 
  $5th_word = $words[4] -replace '\[|[0-9]{1,15}|\]|\:',''

  if ($5th_word_table.ContainsKey($5th_word)) {
    $5th_word_table[$5th_word]++
  }

  else {
    $5th_word_table[$5th_word] = 1
  }

}

# change the property name of the Keys and Values of $5th_word_table
$5th_word_table_Fixed = foreach ($entry in $5th_word_table.GetEnumerator() | Sort-Object Value -Descending) {
  [pscustomobject]@{
    "Event Name" = $entry.Key
    "Count" = $entry.Value
  }
}

# show the event names and counts found in the auth.log file
$5th_word_table_Fixed

# show total events
Write-Output "[Total: $($5th_word_table.Keys.Count)]"
