#invetory of VM´s
#$hosts = Get-Content "d:\hostslist.txt"
Get-VM -ComputerName $hosts | Where { $_.State –eq ‘Running’ } | select ComputerName,name,state | Export-Csv -Path d:\VMList-$((Get-Date).ToString("MM-dd-yyyy")).csv -NoTypeInformation





