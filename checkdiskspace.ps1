
$freeSpaceNeeded = 5


    #if less run disk clean up and check again
    #if still less send mail

Function CheckDiskSpace {
    $drives = gwmi win32_volume -Filter 'drivetype = 3' | select driveletter, label, @{LABEL='GBfreespace';EXPRESSION={$_.freespace/1GB} }
    foreach ($drive in $drives) {
        if ($drive.driveletter -eq "C:") {
            if ($drive.GBfreespace -gt $freeSpaceNeeded) {
                write-host "More than $freeSpaceNeeded GB found on C"
            }
            else {
                write-host "Not enough space on C, need to cleaning"
            }
        }
    }
 
} #end function 

CheckDiskSpace #Check C: for 5GB of free space