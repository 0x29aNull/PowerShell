$Msg = "Enter The PC You Would Like to Find"
Function Map {
  param([String]$GetPC)
  $PC = Get-ADComputer $GetPC
  [array]$Array = $PC -Split(',').ForEach({$_.Split('=')[-1]})
  [array]::Reverse($Array)
  ForEach ($Item in $Array) {
    if ($Item -eq 'DC=com') {
      [array]$NArray += $Array -notmatch 'DC=com'
    }
  }
  Clear
  $NArray -join "`n->"
}

Do
{
  $GetPC = Read-Host -Prompt $Msg
  Try
  {
    Get-ADComputer $GetPC
    Map $GetPC
  }
  Catch
  {
    Write-Output "Error: PC Not Found"
    $GetPC = $null
  }
}
While ($GetPC -eq $null)
