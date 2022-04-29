# TestConn.ps1 - Script 1 or 2, Use with Reconnect.ps1

# Oracle Simphony Micros Computers lose their NICs randomly, This solves that problem.
# Create a Task Scheduler job to run this script with highest priviledges every half hour.
# The task command should be "powershell.exe -WindowStyle hidden C:\NIC\TestConn.ps1"
# Place this script and the Reconnect.ps1 in a folder named "NIC" on the root of C drive.
# Once the script is ran, It will check for a connection, If that connection fails it will
# close the Micros application, Drop the NIC, Enable the NIC, Reconnect then re-launch the
# Simphony application.

$Connection = Test-Connection -ComputerName SERVER -Count 1 -Quiet

if (($Connection) -eq $True){
    Exit }
else { 
    Write-Host "No Reply, Running Script"
    & "C:\NIC\Reconnect.ps1"

 }
