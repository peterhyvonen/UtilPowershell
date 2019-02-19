[string]$vmname = read-host "Please enter the name of the new VM:"
$cpucount = read-host "Please enter the number of CPU cores:"
#$ramsize = read-host "Please enter the amout of ram in GB:"
#$ramsize += "GB"
$jobname = "$vmname Copy VHDX"
$newname = "$vmname.vhdx"
New-Item -ItemType directory -Path D:\Hyper-V\$vmname
$scriptblock = Copy-Item "D:\Hyper-V\Virtual Hard Disks\win2012r2-syspreped.vhdx" "D:\Hyper-V\$vmname\"
$job = start-job -name $jobname -scriptblock {$scriptblock}
wait-job -name $jobname
write-host "Sleeping for a min while drive is being copied"
Start-Sleep -s 120
rename-item "D:\Hyper-V\$vmname\win2012r2-syspreped.vhdx" $newname
New-VM –Name $vmname –MemoryStartupBytes 16GB -Path "d:\Hyper-V" -VHDPath "D:\Hyper-V\$vmname\$vmname.vhdx" -Generation 1
write-host "Disk copied, building VM"
Start-Sleep -s 12
Set-VMProcessor $vmname -Count $cpucount
Remove-VMNetworkAdapter -VMName $vmname -VMNetworkAdapterName "Network Adapter"
Start-Sleep -s 12
Add-VMNetworkAdapter -VMName $vmname -SwitchName "Intel(R) Ethernet 10G 4P X540/I350 rNDC - Virtual Switch"
#Add-VMDvdDrive -VMName $vmname –Path c:\en_windows_server_2012_r2_x64_dvd_2707946.iso