# TestConn.ps1
# Certain Oracle Computers lose their Network Interface Card, This solves that problem.
# Create a Task Scheduler job to run this script with highest priviledges every half hour.
# The task command should be "powershell.exe -WindowStyle hidden C:\NIC\TestConn.ps1"
# Place this script and the Reconnect.ps1 in a folder named "NIC" on the root of C drive.

$Connection = Test-Connection -ComputerName SERVER -Count 1 -Quiet

if (($Connection) -eq $True){
    Exit }
else { 
    Write-Host "No Reply, Running Script"
    & "C:\NIC\Reconnect.ps1"

 }
