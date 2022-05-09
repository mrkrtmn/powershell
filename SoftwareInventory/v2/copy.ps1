$computers = gc "D:\script\lsprb.txt"
foreach ($computer in $computers) {
New-Item -Path "\\$computer\c$" -Name "tempfolderbs" -ItemType "directory"
Copy-Item -Path "D:\script\softwareinstalled.ps1","D:\script\run.bat" -Destination "\\$computer\c$\"
}
