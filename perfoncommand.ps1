$day = (Get-Date).Day
$hr = (Get-Date).Hour
$min = (Get-Date).Minute
$date = "$day-$hr-$min"
Start-Job -Name "PDidle" -ScriptBlock {Get-counter -Counter "\PhysicalDisk(_Total)\% Idle Time" –Continuous | Export-counter -Path C:\temp\PDidle.csv}
Start-Job -Name "PDread" -ScriptBlock {Get-counter -Counter "\PhysicalDisk(_Total)\Avg. Disk sec/Read" –Continuous | Export-counter -Path C:\temp\PDread.csv}
Start-Job -Name "PDwrite" -ScriptBlock {Get-counter -Counter "\PhysicalDisk(_Total)\Avg. Disk sec/Write" –Continuous | Export-counter -Path C:\temp\PDwrite.csv}
Start-Job -Name "PDqueue" -ScriptBlock {Get-counter -Counter "\PhysicalDisk(_Total)\Current Disk Queue Length" –Continuous | Export-counter -Path C:\temp\PDqueue.csv}
Start-Job -Name "RAMavailible" -ScriptBlock {Get-counter -Counter "\Memory\Available Mbytes" –Continuous | Export-counter -Path C:\temp\RAMavailible.csv}
Start-Job -Name "RAMpages" -ScriptBlock {Get-counter -Counter "\Memory\Pages/sec" –Continuous | Export-counter -Path C:\temp\RAMpages.csv}
Start-Job -Name "NICTotalBytes" -ScriptBlock {Get-counter -Counter "\Network Interface(*)\Bytes Total/sec" –Continuous | Export-counter -Path C:\temp\NICtotalbytes.csv}
Start-Job -Name "NICqueue" -ScriptBlock {Get-counter -Counter "\Network Interface(*)\Output Queue Length" –Continuous | Export-counter -Path C:\temp\NICqueue.csv}
Start-Job -Name "PAGING" -ScriptBlock {Get-counter -Counter "\Paging File\%Usage" –Continuous | Export-counter -Path C:\temp\PAGING.csv}
Start-Job -Name "CPU" -ScriptBlock {Get-counter -Counter "\Processor(_Total)\% Processor Time" –Continuous | Export-counter -Path C:\temp\CPU.csv}
Start-Job -Name "Sync" -ScriptBlock {p4.exe sync}
Wait-Job -Name "Sync"
Start-Job -Name "command" -ScriptBlock {$env:commandtorun} # --no-server}
Wait-Job -Name "command"
Write-Output "Procces Complete Begining Cleanup"
Start-Sleep 360
Rename-Item C:\temp\PDidle.csv "PDidle$date.csv"
Rename-Item C:\temp\PDread.csv "PDread$date.csv"
Rename-Item C:\temp\PDwrite.csv "PDwrite$date.csv"
Rename-Item C:\temp\PDqueue.csv "PDqueue$date.csv"
Rename-Item C:\temp\RAMavailible.csv "RAMavailible$date.csv"
Rename-Item C:\temp\RAMpages.csv "RAMpages$date.csv"
Rename-Item C:\temp\NICTotalBytes.csv "NICTotalBytes$date.csv"
Rename-Item C:\temp\NICqueue.csv "NICqueue$date.csv"
Rename-Item C:\temp\Downloads\PAGING.csv "PAGING$date.csv"
Rename-Item C:\temp\CPU.csv "CPU$date.csv"
Start-Sleep 360
Restart-Computer -Force

