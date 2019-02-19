
Function GenerateComputerName
{
    $Length = 11
    $set    = "ABCDEFGHJKMNPQRSTUVWXYZ23456789".ToCharArray()
    $result = ""
    for ($x = 0; $x -lt $Length; $x++) {
        $result += $set | Get-Random
    }
    return "LAB-"  + $result
}

Function GetLocalCred
{
    $User= "local.admin"
	$PWord= ConvertTo-SecureString -String $env:localadminpw -AsPlainText -Force
	$Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
    return $Cred
}

Function Rename-VM
{
    $currentHostname = hostname
    $computerName = GenerateComputerName
    $localCred = GetLocalCred
    
    Write-Host "Renaming from:" $currentHostname " to:" $computerName

    if ($PSVersionTable.PSVersion.Major -le 2)
    {
        Write-Host "Rename PS 2 method."
        Get-WmiObject -Class Win32_ComputerSystem -ComputerName $currentHostname -Authentication 6 |
        ForEach-Object {$_.Rename($computerName,$localCred.Password,$localCred.Username)}
        Restart-Computer -Force        
    }
    else
    {
        Write-Host "Rename PS 3+ method."
        Rename-Computer -LocalCredential $localCred -NewName $computerName -Force
        Restart-Computer -Force
    }
}

Write-Host "Begin checking for network connectivity"
$netCounter = 1
while(!(Test-Connection google.com -Quiet) -and $netCounter -le 6) {
    #Wait until the network connection is ready
    #If the counter reaches 6, it's a minute in, so just let it continue and fail if it still does not connect by then.  This removes the possibility of infinite loops
    Write-Host $netCounter ". No network detected.  Waiting for 10 seconds and trying again"
    Start-Sleep -Seconds 10;
    $netCounter ++;
}

Rename-VM