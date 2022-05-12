# Script to map the path of an Active Directory Computer.
# mlogsdon 05/22

Import-Module ActiveDirectory
$PC = Read-Host "Enter PC Name: "
$Cmd = Get-ADComputer $PC
[array]$Array = $Cmd -Split(',').ForEach({$_.Split('=')[-1]})
[array]::Reverse($Array)

foreach ($item in $Array) {
    if ($item -eq 'DC=com') {
        [array]$NewArray += $Array -notmatch 'DC=com'
    }
}
$NewArray.Count
$NewArray -join "`n->"
