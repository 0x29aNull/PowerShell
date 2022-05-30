# Script to check a remote network PC for termed accounts in Active Directory
# mlogsdon 5/22

 Import-Module ActiveDirectory
 $TmpFile = 'C:\temp\tmpfile.txt'
 $UsrFile = 'C:\temp\Users.txt'
 Function grep {
    $input | Out-String -Stream | Select-String $args
}
  
Function Check {
    $Users = Get-Content -Path $TmpFile
        ForEach($User in $Users) {
            Try
            {
                $Str1 = Get-ADUser -Identity $User | grep 'Termed Accounts'
                $Str2 = $Str1 -Split ('CN=') -Split (',OU')
                $Termed = $Str2[1]
                Add-Content -Path $UsrFile -Value $Termed
            }
            Catch
            {
                $Str3 = $_ -split ("'") 
                $Str4 = $Str3 -split (":")
                $Str5 = $Str4[2]
                $Str6 = "Possible Termed: $Str5"
                Add-Content -Path $UsrFile -Value $Str6
            }  
      }
}
  
Function Content {
    param([String]$PC)
    $Dir = "\\" + $PC + "\c$\Users\"
    ls $Dir -Name | Out-File $TmpFile
    $Clean = Set-Content -Path $TmpFile -Value (Get-Content -Path $TmpFile | Select-String -Pattern 'Public' -NotMatch | Select-String -Pattern 'tasksched' -NotMatch)
    Check
}
  
$GetPC = Read-Host "PC"
Content $GetPC
Remove-Item $TmpFile
notepad.exe $UsrFile
