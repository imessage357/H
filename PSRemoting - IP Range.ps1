function New-IPRange {
<#
.SYNOPSIS
    Returns an array of IP Addresses based on a start and end address

.DESCRIPTION
    Returns an array of IP Addresses based on a start and end address

.PARAMETER Start
    Starting IP Address

.PARAMETER End
    Ending IP Address

.PARAMETER Exclude
    Exclude addresses with this final octet

    Default excludes 0, 1, and 255

    e.g. 5 excludes *.*.*.5

.EXAMPLE
    New-IPRange -Start 192.168.1.5 -End 192.168.20.254

    Create an array from 192.168.1.5 to 192.168.20.254, excluding *.*.*.[0,1,255] (default exclusion)

.NOTES
    Source: Dr. Tobias Weltner, http://powershell.com/cs/media/p/9437.aspx

.FUNCTIONALITY
    Network
#>
[cmdletbinding()]
param (
    [parameter( Mandatory = $true,
                Position = 0 )]
    [System.Net.IPAddress]$Start,

    [parameter( Mandatory = $true,
                Position = 1)]
    [System.Net.IPAddress]$End,

    [int[]]$Exclude = @( 0, 1, 255 )
)
    
    #Provide verbose output.  Some oddities behind casting certain strings to IP.
    #Example: [ipaddress]"192.168.20500"
    Write-Verbose "Parsed Start as '$Start', End as '$End'"
    
    $ip1 = $start.GetAddressBytes()
    [Array]::Reverse($ip1)
    $ip1 = ([System.Net.IPAddress]($ip1 -join '.')).Address

    $ip2 = ($end).GetAddressBytes()
    [Array]::Reverse($ip2)
    $ip2 = ([System.Net.IPAddress]($ip2 -join '.')).Address

    for ($x=$ip1; $x -le $ip2; $x++)
    {
        $ip = ([System.Net.IPAddress]$x).GetAddressBytes()
        [Array]::Reverse($ip)
        if($Exclude -notcontains $ip[3])
        {
            $ip -join '.'
        }
    }
}

$exclude1 = '10.5.3.11', '10.5.3.15',  '10.5.3.242' , '10.9.5.242' , '10.9.4.11' , '10.9.4.15' , '10.9.4.31' , '10.9.4.52', '10.9.4.171' , '10.9.4.190' , '10.9.4.242' , ' 10.9.5.11' , '10.9.5.15' , '10.9.5.15'
$exclude2 = New-IPRange -Start 10.5.3.22 -End 10.5.3.28
$exclude3 = New-IPRange -Start 10.5.3.201 -End 10.5.3.239
$exclude4 = New-IPRange -Start 10.9.4.22 -End 10.9.4.28
$exclude5 = New-IPRange -Start 10.9.4.173 -End 10.9.4.175
$exclude6 = New-IPRange -Start 10.9.4.200 -End 10.9.4.240
$exclude7 = New-IPRange -Start 10.9.5.22 -End 10.9.5.28
$exclude7 = New-IPRange -Start 10.9.5.201 -End 10.9.5.239
$exclude = $exclude1 + $exclude2 + $exclude3 + $exclude4 + $exclude5 + $exclude6  +$exclude7
$ex = $exclude | % {$_.split('.')[3]}
$ex.count

$IPRange1 = New-IPRange -start 10.5.3.1  -end 10.5.3.254 -Exclude $ex
$IPRange2 = New-IPRange -start 10.9.4.1  -end 10.9.4.254 -Exclude $ex
$IPRange3 = New-IPRange -start 10.9.5.1  -end 10.9.5.254 -Exclude $ex
$IPs = $IPRange1 + $IPRange2 + $IPRange3
$IPs.Count

$s = new-PSSession -computername $($IPs)  -ErrorAction SilentlyContinue -Credential $cred



<# Enable your BOX!!
set-item wsman:\localhost\Client\TrustedHosts -value *
Restart-Service winrm -Verbose
gsv winrm
#>