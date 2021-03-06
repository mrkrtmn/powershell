# First lets create a text file, where we will later save the freedisk space info 
# En esta linea se debe colocar la ruta del script
$ScriptPath = "E:\FreeSpaceServerNAL";
cd $ScriptPath 
$freeSpaceFileName = "DiskSpaceRpt_$(get-date -format ddMMyyyy_hhmmss).html";
# Ubicación del archivo txt que contiene el listado de equipos que serán revisados
$serverlist = "$ScriptPath\sl.txt" 
# Parámetros para las alertas
#$warning = 90        # Color rojo para porcentaje
#$critical = 70       # Color amarillo pata porcentaje
$warning = 10
$critical = 30

New-Item -ItemType file $freeSpaceFileName -Force 
# Getting the freespace info using WMI 
#Get-WmiObject win32_logicaldisk  | Where-Object {$_.drivetype -eq 3} | format-table DeviceID, VolumeName,status,Size,FreeSpace | Out-File FreeSpace.txt 
# Function to write the HTML Header to the file 
Function writeHtmlHeader 
{ 
param($fileName) 
$date = ( get-date ).ToString('yyyy/MM/dd') 
Add-Content $fileName "<html>" 
Add-Content $fileName "<head>" 
Add-Content $fileName "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>" 
Add-Content $fileName '<title>DiskSpace Report - Bisa Seguros y Reaseguros S.A.</title>' 
add-content $fileName '<STYLE TYPE="text/css">' 
add-content $fileName  "<!--" 
add-content $fileName  "td {" 
add-content $fileName  "font-family: Tahoma;" 
add-content $fileName  "font-size: 14px;" 
add-content $fileName  "border-top: 1px solid #999999;" 
add-content $fileName  "border-right: 1px solid #999999;" 
add-content $fileName  "border-bottom: 1px solid #999999;" 
add-content $fileName  "border-left: 1px solid #999999;" 
add-content $fileName  "padding-top: 0px;" 
add-content $fileName  "padding-right: 0px;" 
add-content $fileName  "padding-bottom: 0px;" 
add-content $fileName  "padding-left: 0px;" 
add-content $fileName  "}" 
add-content $fileName  "body {" 
add-content $fileName  "margin-left: 5px;" 
add-content $fileName  "margin-top: 5px;" 
add-content $fileName  "margin-right: 0px;" 
add-content $fileName  "margin-bottom: 10px;" 
add-content $fileName  "" 
add-content $fileName  "table {" 
add-content $fileName  "border: thin solid #000000;" 
add-content $fileName  "}" 
add-content $fileName  "-->" 
add-content $fileName  "</style>" 
Add-Content $fileName "</head>" 
Add-Content $fileName "<body>" 
 
add-content $fileName  "<table width='100%'>" 
add-content $fileName  "<tr bgcolor='#CCCCCC'>" 
add-content $fileName  "<td colspan='7' height='25' align='center'>" 
add-content $fileName  "<font face='tahoma' color='#003399' size='4'><strong>DiskSpace Report - $date</strong></font>" 
add-content $fileName  "</td>" 
add-content $fileName  "</tr>" 
add-content $fileName  "</table>" 
 
} 
 
# Function to write the HTML Header to the file 
Function writeTableHeader 
{ 
param($fileName) 
 
Add-Content $fileName "<tr bgcolor=#CCCCCC>" 
Add-Content $fileName "<td width='10%' align='center'>Drive</td>" 
Add-Content $fileName "<td width='50%' align='center'>Drive Label</td>" 
Add-Content $fileName "<td width='10%' align='center'>Total Capacity(GB)</td>" 
Add-Content $fileName "<td width='10%' align='center'>Used Capacity(GB)</td>" 
Add-Content $fileName "<td width='10%' align='center'>Free Space(GB)</td>" 
#Add-Content $fileName "<td width='10%' align='center'>Freespace Alarm</td>" 
Add-Content $fileName "</tr>" 
} 
 
Function writeHtmlFooter 
{ 
param($fileName) 
 
Add-Content $fileName "</body>" 
Add-Content $fileName "</html>" 
} 
 
Function writeDiskInfo 
{ 
param($fileName,$devId,$volName,$frSpace,$totSpace) 
$totSpace=[math]::Round(($totSpace/1073741824),2) #Lee el total de capacidad en KILOBYTES y lo divide para llegar a GIGAS tomando 2 decimales 
$frSpace=[Math]::Round(($frSpace/1073741824),2) #Lee el espacio libre en KILOBYTES y lo divide para llegar a GIGAS tomando 2 decimales
$usedSpace = $totSpace - $frspace 
$usedSpace=[Math]::Round($usedSpace,2) 
#$freePercent = ($frspace/$totSpace)*100 
#$freePercent = [Math]::Round($freePercent,0) 
#$usedPercent = 100 - $freePercent
 #if ($usedPercent -lt $critical) 
 if ($critical -lt $frSpace) 
 { 
 Add-Content $fileName "<tr>" 
 Add-Content $fileName "<td>$devid</td>" 
 Add-Content $fileName "<td>$volName</td>" 
 Add-Content $fileName "<td>$totSpace</td>" 
 Add-Content $fileName "<td>$usedSpace</td>" 
 #Add-Content $fileName "<td>$frSpace</td>" 
 Add-Content $fileName "<td bgcolor='#01DF01' align=center>$frSpace</td>" 
 Add-Content $fileName "</tr>" 
 } 
 elseif ( $warning -ge $frSpace) 
 { 
 Add-Content $fileName "<tr>" 
 Add-Content $fileName "<td>$devid</td>" 
 Add-Content $fileName "<td>$volName</td>" 
 Add-Content $fileName "<td>$totSpace</td>" 
 Add-Content $fileName "<td>$usedSpace</td>" 
 #Add-Content $fileName "<td>$frSpace</td>" 
 Add-Content $fileName "<td bgcolor='#FF0000' align=center>$frSpace</td>" 
 #<td bgcolor='#FF0000' align=center> 
 Add-Content $fileName "</tr>" 
 } 
 else 
 { 
 Add-Content $fileName "<tr>" 
 Add-Content $fileName "<td>$devid</td>" 
 Add-Content $fileName "<td>$volName</td>" 
 Add-Content $fileName "<td>$totSpace</td>" 
 Add-Content $fileName "<td>$usedSpace</td>" 
 #Add-Content $fileName "<td>$frSpace</td>" 
 Add-Content $fileName "<td bgcolor='#FBB917' align=center>$frSpace</td>" 
 # #FBB917 
 Add-Content $fileName "</tr>" 
 } 
} 


Function sendEmail2
{
	$file = "$ScriptPath\$freeSpaceFileName"

	if (test-path $file)
	{
        #$pc = get-content env:computername                    #Computadora donde se ejecuta el script
		$date = ( get-date ).ToString('yyyy/MM/dd') 
		$from = "Reporte_Hyper-V_disk@grupobisa.com"
		$to = "jaliaga@grupobisa.com", "vmedrano@grupobisa.com", "Falcon@grupobisa.com", "epbalboa@grupobisa.com"#,"usuario3@empresa.com"
		#Las direcciones del to deben indicarse con signos de mayor que y menor que.
		$subject = "Disk Space Report - $date"
		$smtpserver = "172.20.100.183"
        $secpasswd = ConvertTo-SecureString "mBNGqbRh1Dv7J.3462TTusK*78#a1Dv$eR" -AsPlainText -Force
        $mycreds = New-Object System.Management.Automation.PSCredential ("Bisa\usrgenrep",$secpasswd)
        $Mensaje = "Reporte de espacio disponible en disco duro en los servidores: $servidores.  Saludos Cordiales,"

		#Con Out-String formateamos el texto
		$body = Get-Content $file | Out-String


		foreach ($recipient in $to)
		{
			write-host "Enviando mail a $to"
			Send-MailMessage -smtpServer $smtpserver -credential $mycreds -from $from -to $recipient -subject $subject  -body $Mensaje -Attachments $file
		}
	}
	else
	{
	write-host "Fichero no encontrado"
	}
}
 
writeHtmlHeader $freeSpaceFileName 
$servidores = ""
foreach ($server in Get-Content $serverlist) 
{ 
 if ($servidores -eq "")
    {
    $servidores= $server
    }
 else
    {
    $servidores= $servidores + ", " + $server
    }     
 Add-Content $freeSpaceFileName "<table width='100%'><tbody>" 
 Add-Content $freeSpaceFileName "<tr bgcolor='#CCCCCC'>" 
 Add-Content $freeSpaceFileName "<td width='100%' align='center' colSpan=6><font face='tahoma' color='#003399' size='2'><strong> $server </strong></font></td>" 
 Add-Content $freeSpaceFileName "</tr>" 
 
 writeTableHeader $freeSpaceFileName 
 write-host $server
 $dp = Get-WmiObject win32_logicaldisk -ComputerName $server |  Where-Object {$_.drivetype -eq 3} 
 foreach ($item in $dp) 
 { 
 Write-Host  $item.DeviceID  $item.VolumeName $item.FreeSpace $item.Size 
 writeDiskInfo $freeSpaceFileName $item.DeviceID $item.VolumeName $item.FreeSpace $item.Size 
 
 } 
} 
writeHtmlFooter $freeSpaceFileName 

sendEmail2

