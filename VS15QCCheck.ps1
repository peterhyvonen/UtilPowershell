Function Get-RegKeys {
    $inreg = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | where {$_.DisplayName -like "Microsoft Visual Studio 2015*"} | Select-Object DisplayName | Format-Table –AutoSize
    return $inreg
}

Function Get-DirInfo {
    $indir1 = Test-Path "C:\Program Files (x86)\Microsoft Visual Studio 14.0"
    $indir2 = Test-Path "C:\ProgramData\Microsoft\VisualStudio\14.0"
    return $indir1, $indir2
}

Function New-Remoting {
    Param ($computer, $mycred)
    $remoting = Test-WSMan $computer
    if ($remoting) {
        $session = New-PSSession -ComputerName $computer -Credential $mycred
        $inreg = Invoke-Command -session $session -ScriptBlock ${function:Get-RegKeys} 
        Write-Output $inreg
        $indir1, $indir2 = Invoke-Command -session $session -ScriptBlock ${function:Get-DirInfo}
        Write-Output "C:\Program Files (x86)\Microsoft Visual Studio 14.0 is $indir1" 
        Write-Output "C:\ProgramData\Microsoft\VisualStudio\14.0 is $indir2"
        }
    else {
        Write-Error "Powershell Remoting Failed"
    }
}


$computers = Get-Content C:\temp\defaultpool.txt
$mycred = Get-Credential
foreach ($computer in $computers) {
    $fqdn = $computer + $env:domain
    New-Remoting -computer $fqdn -mycred $mycred
}