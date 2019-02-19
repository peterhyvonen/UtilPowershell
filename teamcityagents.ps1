# set credentials from secure pass file
$User      =  $env:username
$Password  = $Password  = ConvertTo-SecureString "" -AsPlainText -Force
$Cred      = New-Object System.Management.Automation.PSCredential ($User,$Password)
$tcURI     = $env:teamcityurl
$csv = @()
$i= 01
# get all pools
$agentPools = Invoke-RestMethod -Credential $Cred -Uri $tcURI/httpAuth/app/rest/agentPools/ -Method Get
# get id of the Default pool 
$poolID     = ($agentPools.agentPools.agentPool | Where {$_.name -eq 'default'}).id
# get all agents out of that pool
$agents     = ((Invoke-RestMethod -Credential $Cred -Uri $env:teamcityurl/httpAuth/app/rest/agentPools/id:$poolID/agents -Method Get).agents).agent

# display agents
foreach ($agent in $agents) {
   #$agents = Invoke-RestMethod -Uri env:teamcityurl/httpAuth/app/rest/agents -Method get -Credential builder
   #$agentid = ($agents.agents.agent | where {$_.Name -eq 'servername'}).id
   #$agentinfo = Invoke-RestMethod -Uri $env:teamcityurl/httpAuth/app/rest/agents/id:$agentid -Method get -Credential builder
   $agentid = $agent.id
   $agentinfo = Invoke-RestMethod -Uri $env:teamcityurl/httpAuth/app/rest/agents/id:$agentid -Method get -Credential $Cred
   $cname = $agentinfo.agent.name
   $ip = $agentinfo.agent.ip
   $hostname = [System.Net.Dns]::GetHostEntry("$ip")#.IPAddressToString
   
   if (Test-Connection $cname) {
         $cname
         $hostname.HostName
   }
   else {
        write-host "Need cname on $cname"
        $cname
        $alias = $hostname.HostName
        $alias
        Add-DnsServerResourceRecordCName -Name $cname -HostNameAlias $alias -ZoneName $env:dnszone -ComputerName $env:tccomputername
   }
}