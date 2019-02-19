param ($search4string = "old string",
        $replacement = "new string")

$var = Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
$var.path -replace $search4string, $replacement
Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment -Name Path -Value $var.path