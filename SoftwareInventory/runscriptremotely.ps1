Invoke-command -ComputerName (get-content C:\Users\falcon010\Desktop\slprb.txt) -filepath C:\Users\falcon010\Desktop\softwareinstalled.ps1
$computers = gc "C:\Users\falcon010\Desktop\slprb.txt"
foreach ($computer in $computers) {
Move-Item -Path "\\$computer\c$\*.html" -Destination "F:\reports\"
}


