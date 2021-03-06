Param(
  [string]$Userlist,
  [string]$Serverlist
)

#############################################
Function TestFilePath () {
	if (!$KBlist) {
		Write-Host "You need to use both the Userlist and Severlist switches"
		Write-Host "Example: AddUser2LocalAdmin.ps1 -Userlist C:\Temp\MyFile.txt -ServerList C:\Temp\MyFile.txt"
	}
	elseif (!$Serverlist) {
		Write-Host "You need to use both the KBlist and Severlist switches"
		Write-Host "Example: AddUser2LocalAdmin.ps1 -Userlist C:\Temp\MyFile.txt -ServerList C:\Temp\MyFile.txt"
	}
	else {
		Write-Host "Gathering data from $filePath"
		Write-Host ""
	}
}
Function AddUsers2LocalAdmin () {
	$servers = Get-Content $Serverlist
	$users = Get-Content $Userlist

	foreach ($server in $servers) {
		foreach ($user in $users) {
			Invoke-Command -ComputerName $Server {net localgroup administrators /add $user} 
		}
	Invoke-Command -ComputerName $Server {net localgroup administrators}
	}
}
###################################################################################### 
# *** Entry Point to Script *** 
TestFilePath
AddUsers2LocalAdmin
