# Remote Termed Users
# mlogsdon 5/22

 $File = "C:\temp\Users.txt"
  Function grep {
    $input | Out-String -Stream | Select-String $args
  }
  
  Function Check {
    $Users = Get-Content -Path $File
    ForEach($User in $Users) {
      Try
      {
        $Str1 = Get-ADUser -Identity $User | grep "Termed"
        $Str2 = $Str1 -Split ('CN=') -Split (',OU')
        $Termed = $Str2[1]
        Add-Content -Path C:\temp\termed.txt -Value $Termed
      }
      Catch
      {
        $Str3 = $_ -split ("'") 
        $Str4 = $Str3 -split (":")
        $Str5 = $Str4[2]
        $Str6 = "Possible Termed: $Str5"
        Add-Content -Path C:\temp\termed.txt -Value $Str6
      }
        
    }
  }
  
  Function Derp {
    param([String]$PC)
    ls $Dir -Name | Out-File $File
    $Clean = Set-Content -Path $File -Value (Get-Content -Path $File | Select-String -Pattern 'Public' -NotMatch | Select-String -Pattern 'tasksched' -NotMatch)
    $Dir = "\\" + $PC + "\c$\Users\"
    Check
  }
  
  $GetPC = Read-Host "PC"
  Derp $GetPC
  notepad.exe C:\temp\termed.txt
  Remove-Item $File
