$app = 'everything'
$Source = "https://www.myget.org/F/logs2424/api/v2"
 if (Test-Path -Path 'C:\ProgramData\chocolatey') { Remove-Item -Path 'C:\ProgramData\chocolatey' -Recurse -force }
 iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')) 
 cls
$env:path = "$($env:ALLUSERSPROFILE)\chocolatey\bin;$($env:Path)"
cinst  $app -source $Source --f -y 
