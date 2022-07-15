Import-Module ActiveDirectory

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$TempFile = "C:\temp\Users.txt"
$TermFile = "C:\temp\Termed.txt"

[System.Windows.Forms.Application]::EnableVisualStyles()

$Root = New-Object System.Windows.Forms.Form
$Root.ClientSize = '460,375'
$Root.Text = "Remote Termed Users"
$Root.MaximizeBox = $False
$Root.FormBorderStyle = 'Fixed3D'
$Root.ControlBox = $False
$Root.BackColor = 'Black'

# Label
$Label1 = New-Object System.Windows.Forms.Label
$Label1.Text = "Enumerate Termed Users on PC"
$Label1.AutoSize = $true
$Label1.Width = 50
$Label1.Height = 15
$Label1.Font = 'Courier New,14'
$Label1.ForeColor = 'White'
$Label1.Location = New-Object System.Drawing.Point(70,10)

$Label2 = New-Object System.Windows.Forms.Label
$Label2.Text = "Name or IP:"
$Label2.AutoSize = $true
$Label2.Width = 50
$Label2.Height = 15
$Label2.Font = 'Courier New,11'
$Label2.ForeColor = 'White'
$Label2.Location = New-Object System.Drawing.Point(5,40)

$InputB = New-Object System.Windows.Forms.TextBox
$InputB.Width = 120
$InputB.Height = 15
$InputB.Font = 'Courier New,13'
$InputB.BackColor = 'Black'
$InputB.ForeColor = 'White'
$InputB.Location = New-Object System.Drawing.Point(109,38)

$Bttn1 = New-Object System.Windows.Forms.Button
$Bttn1.Width = 90
$Bttn1.Height = 27
$Bttn1.Font = 'Courier New,13'
$Bttn1.Text = "Scan"
$Bttn1.BackColor = 'Black'
$Bttn1.ForeColor = 'Lime'
$Bttn1.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$Bttn1.FlatAppearance.BorderSize = 0
$Bttn1.Location = New-Object System.Drawing.Point(230,39)

$Bttn2 = New-Object System.Windows.Forms.Button
$Bttn2.Width = 85
$Bttn2.Height = 27
$Bttn2.Font = 'Courier New,13'
$Bttn2.Text = "Close"
$Bttn2.BackColor = 'Black'
$Bttn2.ForeColor = 'Red'
$Bttn2.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$Bttn2.FlatAppearance.BorderSize = 0
$Bttn2.Location = New-Object System.Drawing.Point(320,39)

$Results = New-Object System.Windows.Forms.TextBox
$Results.Width = 450
$Results.Height = 300
$Results.Multiline = $True
$Results.ScrollBars = "Vertical"
$Results.BackColor = 'Black'
$Results.ForeColor = 'Lime'
$Results.Font = 'Courier New,12'
$Results.Location = New-Object System.Drawing.Point(5,70)

$Root.Controls.AddRange(@($Label1, $Label2, $InputB, $Bttn1, $Bttn2, $Results))

Function Translate {
    if ($InputB.Text) {
        $X = $InputB.Text
        RunFunc $X
    }
}

Function ExitScript {
	$Dest = 'C:\Users\malogsdon\Desktop\Termmy.txt'
	$Choice = [System.Windows.Forms.MessageBoxButtons]::yesno
	$OUTPUT = [System.Windows.Forms.MessageBox]::Show("Save Results to File?","",$Choice)
	if ($OUTPUT -eq "YES") {
		Copy-Item -Path $TermFile -Destination $Dest
		[System.Windows.Forms.MessageBox]::Show("File Saved to Desktop")
		$Root.Close()
	} else {
		Remove-Item $TermFile
		$Root.Close()
	}
}

Function grep {
    $input | Out-String -Stream | Select-String $args
}

Function Check {
    param([String]$PC)
    $Header = 'Computer: ' + $PC
    Add-Content -Path $TermFile -Value $Header
    $Users = Get-Content -Path $TempFile
        ForEach($User in $Users) {
            Try
            {
                $Str1 = Get-ADUser -Identity $User | grep 'Termed Accounts'
                $Str2 = $Str1 -Split ('CN=') -Split (',OU')
                $Termed = $Str2[1]
                Add-Content -Path $TermFile -Value $Termed
            }
            Catch
            {
                $Str3 = $_ -split ("'") 
                $Str4 = $Str3 -split (":")
                $Str5 = $Str4[2]
                $Str6 = "Possible Termed: $Str5"
                Add-Content -Path $TermFile -Value $Str6
            }  
      }
      $Results.Lines += Get-Content $TermFile
      $Root.Update()
      Remove-Item $TempFile
}


Function Content {
    param([String]$PC)
    $Dir = "\\" + $PC + "\c$\Users\"
    ls $Dir -Name | Out-File $TempFile
    $Clean = Set-Content -Path $TempFile -Value (Get-Content -Path $TempFile | Select-String -Pattern 'Public' -NotMatch | Select-String -Pattern 'tasksched' -NotMatch)
    Check $PC
}

Function RunFunc {
    param([String]$X)
    if ((Test-Connection -ComputerName $X -Quiet -Count 1) -eq $True) {
    Content $X
    } Elseif ((Test-Connection -ComputerName $X -Quiet -Count 1) -eq $False) {
    [System.Windows.MessageBox]::Show('Computer Not Found')
    $InputB.text = $null
    $Root.Update()
    }
}

$Bttn1.Add_Click({ Translate })
$Bttn2.Add_Click({ ExitScript })

[void]$Root.ShowDialog()
