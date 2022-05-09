$computers = gc "D:\script\lsprb.txt"
foreach ($computer in $computers) {
Move-Item -Path "\\$computer\c$\tempfolderbs\*.html" -Destination "D:\script"
}
foreach ($computer in $computers) {
Remove-Item -Path "\\$computer\c$\tempfolderbs", "\\$computer\c$\*.bat", "\\$computer\c$\*.ps1"
}