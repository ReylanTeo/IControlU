' VBS Script to hide command prompt window

Set objShell = CreateObject("WScript.Shell")

' Check if an argument was provided
If WScript.Arguments.Count = 1 Then
    ' Argument should be the batch script to run
    objShell.Run "cmd /c " & WScript.Arguments(0), 0
Else
    WScript.Echo "Usage: cscript HiddenPrompt.vbs <BatchScript.cmd>"
End If