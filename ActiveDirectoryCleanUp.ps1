$OU = $env:ouindomain # "OU/DC/DC"
$DeleteInDays = 60
$Zone = $emv:domainzone
$DNSServer = $env:dnsserver
$computerNames = Get-ADComputer -SearchBase $OU -Filter '*' | Select -Exp Name
foreach ($computerName in $computerNames){
    if ($computerName.StartsWith($env:searchstring)) {
        #Write-Host "$computerName is a Lab Machine" 
        #$DeleteInDays = 30
    }
    else {
    }
    $computerObject = Get-ADComputer $computerName -Properties *
    $modifiedDate = $computerObject.Modified
    $todayDate = Get-Date 
    $diffDate = NEW-TIMESPAN –Start $modifiedDate –End $todayDate
    if ($diffDate.Days -gt $DeleteInDays) {
        Write-Host "Deleting AD Computer Object $computerName, it is $diffDate.Days old"
        Remove-ADComputer $computerName -confirm:$false
        #$dns = Invoke-Command -ComputerName $env:dnsserver -ScriptBlock {param($computerName, $DNSserver, $zone)Get-DnsServerResourceRecord -Zone $zone -Name $computerName -ComputerName $DNSserver} -args $computerName, $DNSserver, $zone
        #$dns
        #Remove-DnsServerResourceRecord
    }
    else {
        #Write-Host "Doing Nothing to $computerName, it is $diffDate.Days old"
    }
}
