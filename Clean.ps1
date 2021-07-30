$servers = import-csv -path ".\servers.csv" -Delimiter ";"
$cleanCommands = ".\cleancommands.ps1"
$PSExec = "C:\Windows\System32\PSExec.exe"



Write-Host 'Enabling WinRM on local machine'
Enable-PSRemoting -Force
Restart-Service WinRM
#Start-Process -Filepath "winrm" -ArgumentList "quickconfig" -Wait

Foreach($server in $servers){

    Write-Host ('Cleaning server '+$($server.servername))

    $password = ConvertTo-SecureString $($server.pass) -AsPlainText -Force
    $Creds = New-Object System.Management.Automation.PSCredential ($($server.user), $password)
    #"добавить компьютер назначения к значениям параметра конфигурации TrustedHosts. "
    Set-Item WSMan:\localhost\Client\TrustedHosts -Value $($server.servername) -Force

    #Включить WinRM
    Write-Host 'Enabling WinRM on remote host with psexec'
    Start-Process -Filepath "$PSExec" -ArgumentList "\\$($server.servername) -u $($server.user) -p $($server.pass) -h -s  -accepteula -nobanner powershell.exe Enable-PSRemoting –SkipNetworkProfileCheck -Force; Set-NetFirewallRule -Name 'WINRM-HTTP-In-TCP' -RemoteAddress Any"-NoNewWindow -Wait

    
    Write-Host 'Open session on remote host'
    $session = New-PSSession -ComputerName $($server.servername) -Credential $Creds
    
    Write-Host 'Invoking commands on remote host '
    $result = Invoke-Command -Session $session -FilePath $cleanCommands
    Write-Host $result
    
  

}