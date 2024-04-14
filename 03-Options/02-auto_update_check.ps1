# test conection to GitHub domain
$ConnectionStatus = Test-Connection -ComputerName "GitHub.com" -Count 1 -ErrorAction SilentlyContinue

# statment to check if the there is connection to GitHub or not
if ($ConnectionStatus) {
$ConnectionFlag = "True"

# GitHub API URL for the repository releases
$MP_URL = "https://api.github.com/repos/YosfanEilay/MasterParser/releases/latest"

# Use Invoke-RestMethod to make a GET request to the GitHub API
$response = Invoke-RestMethod -Uri $MP_URL -Method Get -ErrorAction Continue

# Extract the version number from the response
$Latestversion = $response.tag_name

}

# execute this if connection to GitHub is NOT reachable
else {
$ConnectionFlag = "False"
}