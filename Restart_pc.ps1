$UsuarioDominio = 'bisa\falco011'
$Names = Read-Host -Prompt "Equipo" 
$PasswordDominio = Read-Host -Prompt "Password:" -AsSecureString 
$CredencialesDominio = New-Object System.Management.Automation.PSCredential ($UsuarioDominio, $PasswordDominio)
Restart-Computer -ComputerName $Names -Credential $CredencialesDominio -Force