Add-VMNetworkAdapter -ComputerName "LPZOPESERV-LAP" -VMName "WS2019" -Name "NICvLAN100" -SwitchName "Internet-ext"
Add-VMNetworkAdapter -ComputerName "LPZOPESERV-LAP" -VMName "WS2019" -Name "NICvLAN200" -SwitchName "Internet-ext"
Add-VMNetworkAdapter -ComputerName "LPZOPESERV-LAP" -VMName "WS2019" -Name "NICvLAN300" -SwitchName "Internet-ext"
Add-VMNetworkAdapter -ComputerName "LPZOPESERV-LAP" -VMName "WS2019" -Name "NICvLAN400" -SwitchName "Internet-ext"

Remove-VMNetworkAdapter -ComputerName "LPZOPESERV-LAP" -VMName "WS2019" -Name "NICvLAN400" -SwitchName "Internet-ext"

Remove-VMNetworkAdapter -VMName "WS2019" -VMNetworkAdapterName "NICvLAN300"