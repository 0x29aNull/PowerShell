# Clone the AD Groups & OU Path of an existing PC to a new PC
# mlogsdon 05/22

Clear
$FileName = '\Members.txt'
$Usr = $env:USERNAME
$File = 'C:\Users\' + $Usr + $FileName
$newPC = Read-Host "Enter Name of new PC"
$origPC = Read-Host "Enter Name of PC to copy"
$Q1 = '$'
$Q2 = $newPC + $Q1

Clear
Function ADMembers {
    Get-ADPrincipalGroupMembership (Get-ADComputer $origPC).DistinguishedName | Select-Object -ExpandProperty name | Out-File $File
    Set-Content -Path $File -Value (Get-Content -Path $File | Select-String -Pattern 'Domain Computers' -NotMatch)

    $Groups = Get-Content $File
    ForEach ($Group in $Groups) {
        #$Group.TrimEnd("          ")
        ADD-ADGroupMember -identity $Group -Members $Q2
        }
            
}

Function MovePC {
    $ADCmd1 = Get-ADComputer $origPC
    $ADCmd2 = ($ADCmd1 -split ',',2)[-1]
    $ADCmd3 = $Q2
    $ADCmd4 = Get-ADComputer $newPC
    Move-ADObject -Identity $ADCmd4 -TargetPath $ADCmd2
    Write-Host The new path for $newPC is..
    [array]$Array = $ADCmd1 -Split(',').ForEach({$_.Split('=')[-1]})
    [array]::Reverse($Array)

    foreach ($item in $Array) {
        if ($item -eq 'DC=com') {
        [array]$NewArray += $Array -notmatch 'DC=com'
        }
    }
    $NewArray -join "`n->"
}

Write-Host "Clone an existing PCs AD Groups and OU path" `n

ADMembers
MovePC

Remove-Item $File
