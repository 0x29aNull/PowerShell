# Script 2 of 2 - Use with TestConn.ps1

$Connection = Test-Connection -ComputerName SERVER -Count 1 -Quiet
$SvcHost = Get-Process ServiceHost -ErrorAction SilentlyContinue

function stopHost {
    if (($SvcHost) -eq $Null) {
		Write-Host "ServiceHost Not Running"
    } elseif (!$SvcHost.HasExited) {
        $SvcHost | Stop-Process -Force
    }
}
    

function Micros {
    stopHost
    Disable-NetAdapter -Name "*" -Confirm:$false
    sleep 3
    Enable-NetAdapter -Name "*" -Confirm:$false
    sleep 60
    & "C:\Micros\Simphony\WebServer\ServiceHost.exe"
}

if (($Connection) -eq $True) { Exit
} Elseif (($Connection) -eq $False) {
    Micros
}
