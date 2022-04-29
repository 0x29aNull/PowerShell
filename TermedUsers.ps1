# Script to Display Termed AD Accounts for removal
# mlogsdon 4/22

Import-Module ActiveDirectory
$TmpFile = 'C:\temp\Users.txt'
ls C:\Users\ -Name | Out-File $TmpFile
$Clean = Set-Content -Path $TmpFile -Value (Get-Content -Path $TmpFile | Select-String -Pattern 'Public' -NotMatch | Select-String -Pattern 'tasksched' -NotMatch)
$Users = Get-Content -Path $TmpFile

function grep {
    $input | out-string -stream | Select-String $args
}


ForEach ($User in $Users){
    $Str1 = Get-ADUser -Identity $User | grep "Information Technology"
    $Str2 = $Str1 -split ('CN=') -split(',OU')
    $Termed = $Str2[1]
    Write-Host "$Termed is termed"
}

Remove-Item $TmpFile
