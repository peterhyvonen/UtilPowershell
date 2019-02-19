param ($service = "",
$listlocation )
$computers = get-content $listlocation

foreach ($computer in $computers) {
    Try {
        Invoke-Command -ComputerName $computer -ScriptBlock {Stop-Service $service} -Args $computer        
    }
    Catch {
        $_
    }
    Try {
        Invoke-Command -ComputerName $computer -ScriptBlock {Set-Service $service -startuptype "manual"} -Args $computer
    }
    Catch {
        $_
    } 
Invoke-Command -ComputerName $computer -ScriptBlock {Get-Service $service} -Args $computer
}