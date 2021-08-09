#logoff all users except current
ForEach ($session in (query user $_ | where-object {($_ -notmatch 'console') -and ($_ -notmatch 'services') -and ($_ -notmatch $env:USERNAME) -and ($_ -notmatch '65536') -and ($_ -notmatch 'ID')})){
    #$sessionstr= $session -split '\s+'
    logoff ($session -split '\s+')[3]#session id 
}


Remove-Item C:\Windows\Temp\* -Recurse -Force
Remove-Item c:\shells*\* -Recurse -Force
Remove-Item C:\XuanZhi*\LDPlayer\* -Recurse -Force
Remove-Item C:\ChangZhi*\LDPlayer\* -Recurse -Force
Remove-Item C:\ChangZhi*\dnplayer*\ -Recurse -Force 
Remove-Item C:\ChangZhi*\ -Recurse -Force
Remove-Item C:\ledian*\LDPlayer\* -Recurse -Force


Remove-Item D:\XuanZhiU*\ -Recurse -Force
Remove-Item D:\ChangZhiU*\ -Recurse -Force
Remove-Item D:\ledianU*\ -Recurse -Force

Remove-Item C:\temp\* -Recurse -Force
Remove-Item C:\sesman_shell\* -Recurse -Force

Remove-Item 'c:\$Recycle.Bin\*' -Recurse -Force


$ip = (Get-WmiObject Win32_NetworkAdapterConfiguration -filter 'IPEnabled=True'|where{$_.DefaultIPGateway}).IPAddress[0]
$lastOctet = $ip.Split('.')[-1]
$Password = "newPWD~~$lastOctet"


net user Administrator $Password
net user u1 $Password
net user u2 $Password
net user u3 $Password
net user u5 $Password
net user u6 $Password
net user u7 $Password
net user u8 $Password
net user u9 $Password
net user u10 $Password
net user u11 $Password

Get-ChildItem -File -Recurse -Path C:\Fileshare\ | %{ Remove-Item -Path $_.FullName -force }
shutdown -r -f -t 30
