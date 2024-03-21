param(
    # Options
    [Parameter(Mandatory = $true)]
    [ValidateSet('Start','Menu','Update','Purge')]
    [string]$Option,

    # Type
    [Parameter(Mandatory = $false)]
    [ValidateSet('All','Raw','Statistics')]
    [string]$Type
)

if ($Option -eq 'Start' -and -not $Type) {
    Write-Output ""
    Write-Output "[!] You cannot run MasterParser without choosing a -Type option."
    Write-Output ""
    Write-Output "[!] This is your -Type value options: ( All / Raw / Statistics )"
    Write-Output ""
    Write-Output "[!] If you don't know what to choose, view the the MasterParser Menu."
    Write-Output ""
    Write-Output "[!] View the Menu like this: .\MasterParser.ps1 -Option Menu"
    Write-Output ""
    $Type = Read-Host "What -Type do you choose to run"

    if ($Type -match "All" -or $Type -match "Raw" -or $Type -match "Statistics") {
    
    }
    
    else {
    Write-Output "[!] You clearly don't know what you doing."
    Write-Output ""
    Write-Output "[!] Please view the Menu before executing MasterParser again."
    Write-Output ""
    Write-Output "[!] You can view the Menu like this: .\MasterParser.ps1 -Option Menu"
    Write-Output ""
    exit
    }
}

# current script version
$CurrentVersion = "v2.4.1"

# tool running path.
$RunningPath = Get-Location

# Dot Sourcing -> 00-Banner.ps1
. "$RunningPath\03-Options\00-Banner.ps1"

# space
Write-Output ""

switch ($Type) {
  
  'All' {
    $TypeFlag = "All"
  }

  'Raw' {
    $TypeFlag = "Raw"
  }

  'Statistics' {
    $TypeFlag = "Statistics"
  }
  
  }

switch ($Option) {
  'Start' {

    # HashTable to store all the $Log names that was analysed by the ParserMaster
    $AnalysedLog = @{}

    # HashTable to store all the $Log names that are not supported by ParserMaster
    $UnsupportedLog = @{}

    #List to contain all the $Log files that found a machtch
    $VerifiedLogList = @()

    # Log Types HashTable.
    $LogTypeList = @{
      'Auth.Log' = 'Empty'
    }

    # variable to store all the files under 01-Logs folder.
    $Logs = Get-Item -Path "$RunningPath\01-Logs\*" | Select-Object -ExpandProperty Name

    # variable to store 0 in it.
    $LogFileCount = 0

    # iterate file names under 01-Logs.
    foreach ($Log in $Logs) {

      # clean the flag in each foreach iteration 
      $WasExtracted = $null

      # each $Log add 1 to $LogFileCount flag.
      $LogFileCount++

      # foreach statment to iterate on each key under $LogTypeList hashtable.
      foreach ($Key in $LogTypeList.Keys) {
        
        # clean this flag each iteration
        $WasExtracted = $null

        # statment to execute if a log file under 01-Logs was found uner $LogTypeList hashtable.
        if ($Log -match $Key) {
    
        # list for match found logs
        $VerifiedLogList += $Log

          # execute this on .gz files.
          if ($Log -like "*.gz") {

            # flag to state that the log was extracted from a GZip
            $WasExtracted = "True"

            # Save GZip file name in a variable
            $GZipName = $Log

            # Specify the .gz file paths
            $archivePath = "$RunningPath\01-Logs\$Log"
            $destinationPath = "$RunningPath\01-Logs\"

            # Create a FileStream to read the .gz file
            $fileStream = [System.IO.File]::OpenRead($archivePath)

            # Create a GZipStream to decompress the file
            $gzipStream = New-Object IO.Compression.GZipStream $fileStream,([IO.Compression.CompressionMode]::Decompress)

            # Create a FileStream to write the decompressed data to
            $destFilePath = Join-Path $destinationPath (Get-Item $archivePath).BaseName
            $destFileStream = [System.IO.File]::Create($destFilePath)

            # Copy data from the compressed stream to the destination file
            $gzipStream.CopyTo($destFileStream)

            # Close the streams
            $gzipStream.Close()
            $fileStream.Close()
            $destFileStream.Close()
            # End of GZip Extraction

            # execute MasterParser on the GZip output file.
            $Log = $Log -replace '\.gz',''
            
            # list for match found logs
            $VerifiedLogList += $Log

            . "$RunningPath\02-LogModules\$Key\$Key.ps1"
            $LogMatchFlag = "True"
            
            $Results = $Log+$RunningTime
            $AnalysedLog[$Results] = $Result = "| Log Name: $Log | Archived From: $GZipName | Running Time: $RunningTime |"

          }

          # execute this on non .gz files.
          else {
            . "$RunningPath\02-LogModules\$Key\$Key.ps1"
            $LogMatchFlag = "True"

            # add log names to this hashtable list
            $Results = $Log+$RunningTime
            $AnalysedLog[$Results] = $Result = "| Log Name: $Log | Archived From: Not Archived | Running Time: $RunningTime |"
            #$Results = $null
          }
        }

        # execute if the the $Log name is not found under $LogTypeList hashtable list
        else {
            $UnsupportedLog[$Log] = "- $Log"
        }

      }

    }

    # if statment to write message if 01-Logs is empty.
    if ($LogFileCount -eq 0) {
      Write-Output "Logs Folder is Empty"
      Write-Output "+------------------+"
      Write-Output "[!] Error: Folder -> $RunningPath\01-Logs is empty!"
      Write-Output "[!] Insert logs into the '01-Logs' folder for the MasterParser to function properly."
      Write-Output ""
    }

    else {
      # print the hashtable of logs that been analyzed by MasterParser
      Write-Output "List of Successfully Analyzed Logs"

      # Initialize variables to store maximum lengths
      $MaxChar_LogNameCut = 0
      $MaxChar_ArchiveCut = 0
      $MaxChar_RunningTimeCut = 0

      foreach ($Key in $AnalysedLog.Keys) {
      
      # Get the fiel name
      $RemoveStart = $AnalysedLog[$Key] -replace '.*Log Name\: ',''
      $LogNameCut = $RemoveStart -replace ' \| Archived From\:.*',''

      # Get the archive status
      $RemoveStart = $AnalysedLog[$Key] -replace '.*Archived From\: ',''
      $ArchiveCut = $RemoveStart -replace ' \| Running Time\:.*',''
    
      # Get the running time
      $RemoveStart = $AnalysedLog[$Key] -replace '.*Running Time\: ',''
      $RunningTimeCut = $RemoveStart -replace ' \|.*',''

      # Update max lengths if necessary
      $MaxChar_LogNameCut = [math]::Max($MaxChar_LogNameCut,$LogNameCut.Length)
      $MaxChar_ArchiveCut = [math]::Max($MaxChar_ArchiveCut,$ArchiveCut.Length)
      $MaxChar_RunningTimeCut = [math]::Max($MaxChar_RunningTimeCut,$RunningTimeCut.Length)
      }

      # flag to stop $Border iteration after first iteration
      $TheFlag = "Enable"

      foreach ($Key in $AnalysedLog.Keys) {
      
      # Get the fiel name
      $RemoveStart = $AnalysedLog[$Key] -replace '.*Log Name\: ',''
      $LogNameCut = $RemoveStart -replace ' \| Archived From\:.*',''

      # Get the archive status
      $RemoveStart = $AnalysedLog[$Key] -replace '.*Archived From\: ',''
      $ArchiveCut = $RemoveStart -replace ' \| Running Time\:.*',''
    
      # Get the running time
      $RemoveStart = $AnalysedLog[$Key] -replace '.*Running Time\: ',''
      $RunningTimeCut = $RemoveStart -replace ' \|.*',''

      $LogNameCut = $LogNameCut.PadRight($MaxChar_LogNameCut)
      $ArchiveCut = $ArchiveCut.PadRight($MaxChar_ArchiveCut)
      $RunningTimeCut = $RunningTimeCut.PadRight($MaxChar_RunningTimeCut)

      $TheResult = "| Log Name: $LogNameCut | Extracted From: $ArchiveCut | Running Time: $RunningTimeCut |"
      
      # multiply $Result.Length with "-" hyfen symbol to get the boarder
      $Border = '-' * ($TheResult.Length - 2)

      # print the result in a table
      if ($TheFlag -match "Enable") {
        Write-Output "+$Border+"
        $TheFlag = "Disable"
        }
      $TheResult
      }
      Write-Output "+$Border+"
      Write-Output ""
    }
    
    # iteration to remove all the logs that found at least 1 time from the $UnsupportedLog hashtable
    foreach ($VLog in $VerifiedLogList) {
        $UnsupportedLog.Remove($VLog)            
    }

    # statment to execute if a log file under 01-Logs NOT found uner $LogTypeList hashtable.
    if ($UnsupportedLog.Values.Count -ge 1) {
      Write-Output "List of Unsupported Logs"
      Write-Output "+----------------------+"
      $UnsupportedLog.Values
      Write-Output ""
    }
  }

  'Update' {

    # Dot Sourcing -> 01-Update.ps1
    . "$RunningPath\03-Options\01-Update.ps1"

    # stop the script here
    exit

  }

  'Menu' {

    # Dot Sourcing -> 03-Menu.ps1
    . "$RunningPath\03-Options\03-Menu.ps1"

    # stop the script here
    exit
  }

  'Purge' {

    # Dot Sourcing -> 03-Menu.ps1
    . "$RunningPath\03-Options\04-Purge.ps1"

    # stop the script here
    exit
  }
}
