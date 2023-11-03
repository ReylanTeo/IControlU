@echo off
if "%~1"=="" (
    echo Usage: InvisibleShell.cmd ^<BatchScript.cmd^>
    exit /b 1
)

start /b "" cmd /c "%~1"