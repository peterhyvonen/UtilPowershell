Param ($program = "no program selected")

Write-Output "Attempting to uninstall the following program: $program"

#Note running Win32_Product will reconfigure all software on machine, dont do to a live machine
$apps = Get-WmiObject -Class Win32_Product | Where-Object { 
    $_.Name -match $program 
}
if ($apps) {
    foreach ($app in $apps) {
        Stop-Service $app.Name -Force -Confirm
        Start-Sleep 120
        Start-Service $app.Uninstall() -Wait -PassThru
        Start-Sleep 120
        #Remove-Item C:\ProgramData\PuppetLabs -Recurse
    }
}
New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR

Set-Location HKCR:


$keys = Get-ChildItem "HKCR:\Installer\Products"
$string = "Installer\Products\"

foreach($key in $keys){
    $product = $key.getvalue(“ProductName”)

    if ($product -match $program){
        Write-Host "Found $program GUID"
        $id = ($key.Name).Split("\")

        $id[3]
        $string += $id[3]
        Remove-Item $string -Recurse
    }
}