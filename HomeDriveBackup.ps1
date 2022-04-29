$Today = Get-Date -Format "MMddyyyy"
$User = $env:UserName
$Path = "\\path.to.homeshares\user\"
$uPath = $Path + $User
$Backup = $uPath + '\Backup' + $Today
$Desktop = $Backup + '\Desktop'
$Email = $Backup + '\Outlook'
$Documents = $Backup + '\Documents'
$Downloads = $Backup + '\Downloads'
$Bookmarks = $Backup + '\Bookmarks'
$AS400 = $Backup + '\AS400'
$Chrome = "C:\Users\$User\AppData\Local\Google\Chrome\User Data\Default\"
$Firefox = $env:APPDATA + '\Mozilla\Firefox\Profiles\*-release\'
$Edge = "C:\Users\$User\AppData\Local\Microsoft\Edge\User Data\Default\"

if ((Test-Path $uPath) -eq $false) {
    Write-Host "Path does not exist"
} else {
    New-Item -ItemType Directory $Backup
    New-Item -ItemType Directory $Desktop
    New-Item -ItemType Directory $Documents
    New-Item -ItemType Directory $Downloads
    New-Item -ItemType Directory $Bookmarks
    New-Item -ItemType Directory $AS400 } 

if ((Test-Path "C:\AS400\*.hod") -eq $true) {
    Copy-Item -Path "C:\AS400\*.hod" -Destination $AS400 -Recurse }

if ((Test-Path $Chrome) -eq $true) {
    New-Item -ItemType Directory "$Bookmarks\Chrome\"
    Copy-Item -Path "$Chrome\Bookmarks*" -Destination "$Bookmarks\Chrome\" }

if ((Test-Path $Firefox) -eq $true) {
    New-Item -ItemType Directory "$Bookmarks\Firefox\"
    Copy-Item -Path "$Firefox\bookmarkbackups" -Destination "$Bookmarks\Firefox\" -Recurse }

if ((Test-Path "$Edge\Bookmarks*") -eq $true) {
    New-Item -ItemType Directory "$Bookmarks\Edge\"
    Copy-Item -Path "$Edge\Bookmarks*" -Destination "$Bookmarks\Edge\" -Recurse }

Write-Host "Generating List of Installed Software"
Echo "User Installed Programs" | Out-File -FilePath "$Backup\Software.txt" -Append
Echo "---------------" | Out-File -FilePath "$Backup\Software.txt" -Append
Get-ChildItem $env:APPDATA -Name | Out-File -FilePath "$Backup\Software.txt" -Append
Echo " " | Out-File -FilePath "$Backup\Software.txt" -Append
if ((Test-Path -Path 'C:\Program Files') -eq $true) {
    Echo "64 Bit Programs" | Out-File -FilePath "$Backup\Software.txt" -Append
    Echo "---------------" | Out-File -FilePath "$Backup\Software.txt" -Append
    Get-ChildItem 'C:\Program Files' -Name | Out-File -FilePath "$Backup\Software.txt" -Append
    Echo " " | Out-File -FilePath "$Backup\Software.txt" -Append }

Echo "32 Bit Programs" | Out-File -FilePath "$Backup\Software.txt" -Append
Echo "---------------" | Out-File -FilePath "$Backup\Software.txt" -Append
Get-ChildItem 'C:\Program Files (x86)' -Name | Out-File -FilePath "$Backup\Software.txt" -Append
Set-Content -Path $Backup\Software.txt -Value (Get-Content -Path $Backup\Software.txt | Select-String -Pattern 'Windows' -NotMatch)

Copy-Item -Path C:\Users\$User\Desktop\* -Destination $Backup\Desktop\ -Recurse
Remove-Item $Backup\Desktop\*.lnk
Copy-Item -Path C:\Users\$User\Downloads\* -Destination $Backup\Downloads\ -Recurse
Copy-Item -Path C:\Users\$User\Documents\* -Destination $Backup\Documents\ -Recurse
Copy-Item -Path C:\Users\$User\My Documents\* -Destination $Backup\Documents\ -Recurse
Copy-Item -Path C:\Users\$User\Favorites\* -Destination $Backup\Bookmarks\ -Recurse
