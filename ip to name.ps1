$IPFILE = Get-Content C:\Users\falcon010\Desktop\list.txt
$results=@()
foreach ($IP in $IPFILE){
$o=Resolve-DNSName $IP | Select-Object -Property NameHost, @{name='IP';expression={$IP}}
$results+=$o
}
$results