#Peter Hyvonen 11/05/2014 for Tableau Software with git
Param(
  [string]$KBlist,
  [string]$Serverlist
)
################################################
Function TestFilePath () {
	if (!$KBlist) {
		Write-Host "You need to use both the KBlist and Severlist switches"
		Write-Host "Example: KBCheck.ps1 -KBlist C:\Temp\MyFile.txt -ServerList C:\Temp\MyFile.txt"
	}
	elseif (!$Serverlist) {
		Write-Host "You need to use both the KBlist and Severlist switches"
		Write-Host "Example: KBCheck.ps1 -KBlist C:\Temp\MyFile.txt -ServerList C:\Temp\MyFile.txt"
	}
	else {
		Write-Host "Gathering data from $filePath"
		Write-Host ""
	}
}
Function Check4KBs () {
	$servers = Get-Content $Serverlist
	$kbs = Get-Content $KBlist

	foreach ($server in $servers) {
		foreach ($kb in $kbs) {
			$results = Get-WmiObject -ComputerName $server -Class WIN32_QuickFixEngineering | Where-Object{$_.HotFixID -like $kb}
			if (!$results) {
				Write-Host "$kb not found on $server" -foreground Red
			}
			else {
				Write-Host "$kb found on $server" -foreground Green
			}
		}
	}
}

TestFilePath
Check4KBs