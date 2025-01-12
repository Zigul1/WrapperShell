# Caricamento .NET System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Shell non visualizzata
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
'
$consolePtr = [Console.Window]::GetConsoleWindow()
[Console.Window]::ShowWindow($consolePtr, 0)


# Impostazione Form principale
$main_form = New-Object System.Windows.Forms.Form
$main_form.Text ='W R A P P E R S H E L L'
$main_form.Opacity = 0.95
$main_form.AutoSize = $true
$main_form.BackColor = "#434c56"
$main_form.ForeColor = "#ffffff"
$main_form.StartPosition = "CenterScreen"
$main_form.FormBorderStyle = "FixedSingle"


# Testo intro
[System.Windows.Forms.Label]$intro = @{
    Text = "This script creates 'carrier.ps1' file, that can contain text (on the right) and one image (on 
the left). The file can be password protected (AES 256) and can self-destruct. Some of the
elements can be customized using the section below."
    Font = "Verdana, 11"
    Location = New-Object System.Drawing.Point(10,20)
    AutoSize = $true
}
$main_form.Controls.Add($intro)


# Scelta immagine
[System.Windows.Forms.Label]$Img = @{
    Text = "Choose the image to put on the left (optional)"
    Font = "Verdana, 11"
    Location = New-Object System.Drawing.Point(10,90)
    AutoSize = $true
}
$main_form.Controls.Add($Img)

[System.Windows.Forms.Button]$ButtonImg = @{
    Location = New-Object System.Drawing.Point(10,115)
    Size = New-Object System.Drawing.Size(110,30)
    Text = "FILE"
    Font = "Verdana, 11"
    BackColor = "#101c28"
}
$main_form.Controls.Add($ButtonImg)

[System.Windows.Forms.Label]$LabelImgO = @{
    Font = "Verdana, 11"
    Location = New-Object System.Drawing.Point(140,118)
    Size = New-Object System.Drawing.Size(590,25)
    AutoEllipsis = $true
    BackColor = "#101c28"
}
$main_form.Controls.Add($LabelImgO)

Function FileImg ($InitialDirectory) {
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.Title = "Choose an image"
    $OpenFileDialog.InitialDirectory = $InitialDirectory
    $OpenFileDialog.filter = “All files (*.*)| *.*”
    If ($OpenFileDialog.ShowDialog() -eq "Cancel") {
        [System.Windows.Forms.MessageBox]::Show("No file selected", "Warning", 0,
        [System.Windows.Forms.MessageBoxIcon]::Exclamation) | Out-Null
        return $Global:ImgFile = $null, $Global:ImgPath = $null
    } else {
        $Global:ImgFile = $OpenFileDialog.SafeFileName
        $Global:ImgPath = $OpenFileDialog.FileName
        Return $ImgFile
    }
}

$ButtonImg.Add_Click({
    $textBoxPS1.Text = ""
    $LabelImgO.Text = FileImg
    $tooltip1 = New-Object System.Windows.Forms.ToolTip
    $tooltip1.SetToolTip($LabelImgO, $ImgPath)
})


# Scelta testo
[System.Windows.Forms.Label]$txt = @{
    Text = "Choose the text to put on the right (optional); if needed, activate the scrollbar (see below)"
    Font = "Verdana, 11"
    Location = New-Object System.Drawing.Point(10,160)
    AutoSize = $true
}
$main_form.Controls.Add($txt)

$text = New-Object System.Windows.Forms.TextBox
$text.Location = New-Object System.Drawing.Point(10,185)
$text.Size = New-Object System.Drawing.Size(720,80)
$text.Font = "Verdana, 11"
$text.BackColor = "#1d1e25"
$text.ForeColor = "#ffffff"
$text.Multiline = $true
$text.ScrollBars = "vertical"
$text.Add_GotFocus({$text.BackColor = "#000000"})
$text.Add_LostFocus({$text.BackColor = "#1d1e25"})
$main_form.Controls.Add($text)


# Salvataggio script carrier.ps1
[System.Windows.Forms.Label]$LabelSave = @{
    Text = "Choose where to save 'carrier.ps1'"
    Font = "Verdana, 11"
    Location = New-Object System.Drawing.Point(10,280)
    AutoSize = $true
}
$main_form.Controls.Add($LabelSave)

[System.Windows.Forms.Button]$ButtonSave = @{
    Location = New-Object System.Drawing.Point(10,305)
    Size = New-Object System.Drawing.Size(110,30)
    Text = "SAVE TO..."
    Font = "Verdana, 11"
    BackColor = "#101c28"
}
$main_form.Controls.Add($ButtonSave)

$ButtonSave.Add_Click({
    $textBoxPS1.Text = ""
    $folder = New-Object System.Windows.Forms.FolderBrowserDialog
    $folder.ShowDialog() | Out-Null
    $LabelSaveP.Text = "$($folder.SelectedPath)\carrier.ps1"
    $ButtonGoTo.Visible = $true
})

[System.Windows.Forms.Label]$LabelSaveP = @{
    Font = "Verdana, 11"
    Location = New-Object System.Drawing.Point(140,307)
    Size = New-Object System.Drawing.Size (470,25)
    AutoEllipsis = $true
    BackColor = "#101c28"
}
$main_form.Controls.Add($LabelSaveP)

[System.Windows.Forms.Button]$ButtonGoTo = @{
    Location = New-Object System.Drawing.Point(620,305)
    Size = New-Object System.Drawing.Size(110,30)
    Text = "FOLDER"
    Font = "Verdana, 11"
    BackColor = "#101c28"
    Visible = $false
}
$main_form.Controls.Add($ButtonGoTo)

$ButtonGoTo.Add_Click({
    explorer "$(($LabelSaveP.Text) | Split-Path -Parent)"
})


# Impostazione password
[System.Windows.Forms.CheckBox]$CheckBoxS = @{
    Text = " Protect 'carrier.ps1' with a password (> 6 characters):"
    Font = "Verdana, 11"
    BackColor = "#31694b"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(10,345)
}
$main_form.Controls.Add($CheckBoxS)

$ptext = New-Object System.Windows.Forms.TextBox
$ptext.Location = New-Object System.Drawing.Point(470,345)
$ptext.Size = New-Object System.Drawing.Size(260,30)
$ptext.Font = "Verdana, 11"
$ptext.BackColor = "#1d1e25"
$ptext.ForeColor = "#ffffff"
$ptext.Add_GotFocus({$ptext.BackColor = "#000000"})
$ptext.Add_LostFocus({$ptext.BackColor = "#1d1e25"})
$main_form.Controls.Add($ptext)


# Autodistruzione
[System.Windows.Forms.CheckBox]$CheckBoxD = @{
    Text = " Self-destruct 'carrier.ps1' after             seconds from its execution"
    Font = "Verdana, 11"
    BackColor = "#46110b"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(10,380)
}
$main_form.Controls.Add($CheckBoxD)

$stext = New-Object System.Windows.Forms.TextBox
$stext.Location = New-Object System.Drawing.Point(275,380)
$stext.Size = New-Object System.Drawing.Size(50,30)
$stext.Font = "Verdana, 11"
$stext.BackColor = "#1d1e25"
$stext.ForeColor = "#ffffff"
$stext.Add_GotFocus({$stext.BackColor = "#000000"})
$stext.Add_LostFocus({$stext.BackColor = "#1d1e25"})
$main_form.Controls.Add($stext)
$stext.BringToFront()


# Sezione personalizzazione grafica ed elementi
[System.Windows.Forms.Label]$LabelC = @{
    Font = "Verdana, 11"
    Location = New-Object System.Drawing.Point(10,500)
    AutoSize = $true
    BackColor = "#716a45"
    Text = " ELEMENTS CUSTOMIZATION"
}
$main_form.Controls.Add($LabelC)

[System.Windows.Forms.Button]$InfoButton = @{
    Location = New-Object System.Drawing.Point(240,498)
    Size = New-Object System.Drawing.Size(23,23)
    Text = "?"
    Font = "Verdana, 11"
    BackColor = "#000677"
    ForeColor = "#ffffff"
}
$main_form.Controls.Add($InfoButton)

$InfoButton.Add_Click({
    [System.Windows.Forms.MessageBox]::Show(@"
- The HEX colors must have #123456 format
- If the text is not fully displayed in the right section, scrollbar can be activated
- If it's decided to insert only one image (also GIF) or some text, it's necessary to put 100 in the corresponding percentage and 0 in the other (do not leave it blank)
- The code for the buttons, being a one-liner, must use ";" as separator among code lines
- Buttons belongs to the text section (right), they will not be displayed if there's an image tha fills the window
"@, "INFO", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Question)
})


# Pannello impostazioni personalizzate
$Panel = New-Object System.Windows.Forms.Panel
$Panel.Location = New-Object System.Drawing.Point(10,525)
$Panel.Size = New-Object System.Drawing.Size(720,270)
$Panel.BackColor = "#434c56"
$main_form.Controls.Add($Panel)

$Panel.Add_Paint({
    param($sender, $e)
    $borderColor = [System.Drawing.Color]::White
    $borderWidth = 2
    $e.Graphics.DrawRectangle((New-Object System.Drawing.Pen($borderColor, $borderWidth)), 0, 0, $Panel.Width - $Width, $Panel.Height - $Width)
})

[System.Windows.Forms.Label]$Label0 = @{
    Font = "Verdana, 10"
    Location = New-Object System.Drawing.Point(10,10)
    AutoSize = $true
    Text = "Window dimensions: width           px - height           px (default 800 x 400)"
}
$Panel.Controls.Add($Label0)

$winW = New-Object System.Windows.Forms.TextBox
$winW.Location = New-Object System.Drawing.Point(190,8)
$winW.Size = New-Object System.Drawing.Size(50,20)
$winW.Font = "Verdana, 10"
$winW.BackColor = "#1d1e25"
$winW.ForeColor = "#ffffff"
$winW.Add_GotFocus({$winW.BackColor = "#000000"})
$winW.Add_LostFocus({$winW.BackColor = "#1d1e25"})
$Panel.Controls.Add($winW)
$winW.BringToFront()

$winH = New-Object System.Windows.Forms.TextBox
$winH.Location = New-Object System.Drawing.Point(320,8)
$winH.Size = New-Object System.Drawing.Size(50,20)
$winH.Font = "Verdana, 10"
$winH.BackColor = "#1d1e25"
$winH.ForeColor = "#ffffff"
$winH.Add_GotFocus({$winH.BackColor = "#000000"})
$winH.Add_LostFocus({$winH.BackColor = "#1d1e25"})
$Panel.Controls.Add($winH)
$winH.BringToFront()

[System.Windows.Forms.Label]$Label1 = @{
    Font = "Verdana, 10"
    Location = New-Object System.Drawing.Point(10,40)
    AutoSize = $true
    Text = "Windows: background (HEX)                - text color                -  SCROLLBAR        "
}
$Panel.Controls.Add($Label1)

$winC = New-Object System.Windows.Forms.TextBox
$winC.Location = New-Object System.Drawing.Point(205,38)
$winC.Size = New-Object System.Drawing.Size(70,20)
$winC.Font = "Verdana, 10"
$winC.BackColor = "#1d1e25"
$winC.ForeColor = "#ffffff"
$winC.Add_GotFocus({$winC.BackColor = "#000000"})
$winC.Add_LostFocus({$winC.BackColor = "#1d1e25"})
$Panel.Controls.Add($winC)
$winC.BringToFront()

$toolTip = New-Object System.Windows.Forms.ToolTip
$toolTip.SetToolTip($winC, "#123456")

$winT = New-Object System.Windows.Forms.TextBox
$winT.Location = New-Object System.Drawing.Point(360,38)
$winT.Size = New-Object System.Drawing.Size(70,20)
$winT.Font = "Verdana, 10"
$winT.BackColor = "#1d1e25"
$winT.ForeColor = "#ffffff"
$winT.Add_GotFocus({$winT.BackColor = "#000000"})
$winT.Add_LostFocus({$winT.BackColor = "#1d1e25"})
$Panel.Controls.Add($winT)
$winT.BringToFront()

$toolTip.SetToolTip($winT, "#123456")

$radioButton1 = New-Object System.Windows.Forms.RadioButton
$radioButton1.Text = "Yes"
$radioButton1.ForeColor = "#ffffff"
$radioButton1.Font = "Verdana, 10"
$radioButton1.Location = New-Object System.Drawing.Point(535,38)
$Panel.Controls.Add($radioButton1)
$radioButton1.BringToFront()

$radioButton2 = New-Object System.Windows.Forms.RadioButton
$radioButton2.Text = "No (default)"
$radioButton2.Size = New-Object System.Drawing.Size(110,20)
$radioButton2.ForeColor = "#ffffff"
$radioButton2.Font = "Verdana, 10"
$radioButton2.Location = New-Object System.Drawing.Point(580,40)
$Panel.Controls.Add($radioButton2)
$radioButton2.BringToFront()

[System.Windows.Forms.Label]$Label2 = @{
    Font = "Verdana, 10"
    Location = New-Object System.Drawing.Point(10,70)
    AutoSize = $true
    Text = "Dimensions in % of left section (image)         and right section (text)         (default 50 - 50)"
}
$Panel.Controls.Add($Label2)

$imP = New-Object System.Windows.Forms.TextBox
$imP.Location = New-Object System.Drawing.Point(285,68)
$imP.Size = New-Object System.Drawing.Size(35,20)
$imP.Font = "Verdana, 10"
$imP.BackColor = "#1d1e25"
$imP.ForeColor = "#ffffff"
$imP.Add_GotFocus({$imP.BackColor = "#000000"})
$imP.Add_LostFocus({$imP.BackColor = "#1d1e25"})
$Panel.Controls.Add($imP)
$imP.BringToFront()

$teP = New-Object System.Windows.Forms.TextBox
$teP.Location = New-Object System.Drawing.Point(485,68)
$teP.Size = New-Object System.Drawing.Size(35,20)
$teP.Font = "Verdana, 10"
$teP.BackColor = "#1d1e25"
$teP.ForeColor = "#ffffff"
$teP.Add_GotFocus({$teP.BackColor = "#000000"})
$teP.Add_LostFocus({$teP.BackColor = "#1d1e25"})
$Panel.Controls.Add($teP)
$teP.BringToFront()

[System.Windows.Forms.CheckBox]$box1 = @{
    Font = "Verdana, 10"
    Location = New-Object System.Drawing.Point(10,100)
    AutoSize = $true
    Text = "Add button 1: background (HEX)                - text color               - text        "
}
$Panel.Controls.Add($box1)

$b1b = New-Object System.Windows.Forms.TextBox
$b1b.Location = New-Object System.Drawing.Point(248,98)
$b1b.Size = New-Object System.Drawing.Size(70,20)
$b1b.Font = "Verdana, 10"
$b1b.BackColor = "#1d1e25"
$b1b.ForeColor = "#ffffff"
$b1b.Add_GotFocus({$b1b.BackColor = "#000000"})
$b1b.Add_LostFocus({$b1b.BackColor = "#1d1e25"})
$Panel.Controls.Add($b1b)
$b1b.BringToFront()

$toolTip.SetToolTip($b1b, "#123456")

$b1t = New-Object System.Windows.Forms.TextBox
$b1t.Location = New-Object System.Drawing.Point(400,98)
$b1t.Size = New-Object System.Drawing.Size(70,20)
$b1t.Font = "Verdana, 10"
$b1t.BackColor = "#1d1e25"
$b1t.ForeColor = "#ffffff"
$b1t.Add_GotFocus({$b1t.BackColor = "#000000"})
$b1t.Add_LostFocus({$b1t.BackColor = "#1d1e25"})
$Panel.Controls.Add($b1t)
$b1t.BringToFront()

$toolTip.SetToolTip($b1t, "#123456")

$b1tx = New-Object System.Windows.Forms.TextBox
$b1tx.Location = New-Object System.Drawing.Point(515,98)
$b1tx.Size = New-Object System.Drawing.Size(120,20)
$b1tx.Font = "Verdana, 10"
$b1tx.BackColor = "#1d1e25"
$b1tx.ForeColor = "#ffffff"
$b1tx.Add_GotFocus({$b1tx.BackColor = "#000000"})
$b1tx.Add_LostFocus({$b1tx.BackColor = "#1d1e25"})
$Panel.Controls.Add($b1tx)
$b1tx.BringToFront()

[System.Windows.Forms.Label]$Label4 = @{
    Font = "Verdana, 10"
    Location = New-Object System.Drawing.Point(10,125)
    AutoSize = $true
    Text = "Button 1 function (PowerShell code):"
}
$Panel.Controls.Add($Label4)

$code1 = New-Object System.Windows.Forms.TextBox
$code1.Location = New-Object System.Drawing.Point(10,150)
$code1.Size = New-Object System.Drawing.Size(600,20)
$code1.Font = "Verdana, 10"
$code1.BackColor = "#1d1e25"
$code1.ForeColor = "#ffffff"
$code1.Add_GotFocus({$code1.BackColor = "#000000"})
$code1.Add_LostFocus({$code1.BackColor = "#1d1e25"})
$Panel.Controls.Add($code1)

[System.Windows.Forms.Button]$Script1 = @{
    Location = New-Object System.Drawing.Point(620,148)
    Size = New-Object System.Drawing.Size(90,25)
    Text = "Add PS1"
    Font = "Verdana, 10"
    BackColor = "#101c28"
}
$panel.Controls.Add($Script1)

Function File1PS1 ($InitialDirectory) {
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.Title = "Select a PS1 script"
    $OpenFileDialog.InitialDirectory = $InitialDirectory
    $OpenFileDialog.filter = “PS1 files (*.ps1)|*.ps1”
    If ($OpenFileDialog.ShowDialog() -eq "Cancel") {
        [System.Windows.Forms.MessageBox]::Show("No script selected", "Error", 0,
        [System.Windows.Forms.MessageBoxIcon]::Exclamation) | Out-Null
        $Script1.ForeColor = "#ffffff"
		$LabelS1.SendToBack()
        $box1.Checked = $false
        return $Global:1PS1File = $false
    } else {
        $Script1.ForeColor = "#00ff00"
        $LabelS1.BringToFront()
        $box1.Checked = $true
        $Global:1PS1File = $OpenFileDialog.FileName
        $LabelS1.text = $1PS1File
        Return $1PS1File
    }
}

$Script1.Add_Click({
    File1PS1
	$code1.text = ""
})

[System.Windows.Forms.Label]$LabelS1 = @{
    Font = "Verdana, 11"
    Location = New-Object System.Drawing.Point(10,150)
    Size = New-Object System.Drawing.Size(600,25)
    AutoEllipsis = $true
    BackColor = "#101c28"
}
$panel.Controls.Add($LabelS1)

[System.Windows.Forms.CheckBox]$box2 = @{
    Font = "Verdana, 10"
    Location = New-Object System.Drawing.Point(10,185)
    AutoSize = $true
    Text = "Add button 2: background (HEX)                - text color               - text        "
}
$Panel.Controls.Add($box2)

$b2b = New-Object System.Windows.Forms.TextBox
$b2b.Location = New-Object System.Drawing.Point(247,182)
$b2b.Size = New-Object System.Drawing.Size(70,20)
$b2b.Font = "Verdana, 10"
$b2b.BackColor = "#1d1e25"
$b2b.ForeColor = "#ffffff"
$b2b.Add_GotFocus({$b2b.BackColor = "#000000"})
$b2b.Add_LostFocus({$b2b.BackColor = "#1d1e25"})
$Panel.Controls.Add($b2b)
$b2b.BringToFront()

$toolTip.SetToolTip($b2b, "#123456")

$b2t = New-Object System.Windows.Forms.TextBox
$b2t.Location = New-Object System.Drawing.Point(400,182)
$b2t.Size = New-Object System.Drawing.Size(70,20)
$b2t.Font = "Verdana, 10"
$b2t.BackColor = "#1d1e25"
$b2t.ForeColor = "#ffffff"
$b2t.Add_GotFocus({$b2t.BackColor = "#000000"})
$b2t.Add_LostFocus({$b2t.BackColor = "#1d1e25"})
$Panel.Controls.Add($b2t)
$b2t.BringToFront()

$toolTip.SetToolTip($b2t, "#123456")

$b2tx = New-Object System.Windows.Forms.TextBox
$b2tx.Location = New-Object System.Drawing.Point(515,182)
$b2tx.Size = New-Object System.Drawing.Size(120,20)
$b2tx.Font = "Verdana, 10"
$b2tx.BackColor = "#1d1e25"
$b2tx.ForeColor = "#ffffff"
$b2tx.Add_GotFocus({$b2tx.BackColor = "#000000"})
$b2tx.Add_LostFocus({$b2tx.BackColor = "#1d1e25"})
$Panel.Controls.Add($b2tx)
$b2tx.BringToFront()

[System.Windows.Forms.Label]$Label6 = @{
    Font = "Verdana, 10"
    Location = New-Object System.Drawing.Point(10,210)
    AutoSize = $true
    Text = "Button 2 function (PowerShell code):"
}
$Panel.Controls.Add($Label6)

$code2 = New-Object System.Windows.Forms.TextBox
$code2.Location = New-Object System.Drawing.Point(10,235)
$code2.Size = New-Object System.Drawing.Size(600,80)
$code2.Font = "Verdana, 10"
$code2.BackColor = "#1d1e25"
$code2.ForeColor = "#ffffff"
$code2.Add_GotFocus({$code2.BackColor = "#000000"})
$code2.Add_LostFocus({$code2.BackColor = "#1d1e25"})
$Panel.Controls.Add($code2)

[System.Windows.Forms.Button]$Script2 = @{
    Location = New-Object System.Drawing.Point(620,233)
    Size = New-Object System.Drawing.Size(90,25)
    Text = "Add PS1"
    Font = "Verdana, 10"
    BackColor = "#101c28"
}
$panel.Controls.Add($Script2)

Function File2PS1 ($InitialDirectory) {
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.Title = "Select a PS1 script"
    $OpenFileDialog.InitialDirectory = $InitialDirectory
    $OpenFileDialog.filter = “PS1 files (*.ps1)|*.ps1”
    If ($OpenFileDialog.ShowDialog() -eq "Cancel") {
        [System.Windows.Forms.MessageBox]::Show("No script selected", "Error", 0,
        [System.Windows.Forms.MessageBoxIcon]::Exclamation) | Out-Null
        $Script2.ForeColor = "#ffffff"
        $LabelS2.SendToBack()
        $box2.Checked = $false
        return $Global:2PS1File = $false
    } else {
        $Script2.ForeColor = "#00ff00"
        $LabelS2.BringToFront()
        $box2.Checked = $true
        $Global:2PS1File = $OpenFileDialog.FileName
        $LabelS2.text = $2PS1File
        Return $2PS1File
    }
}

$Script2.Add_Click({
    File2PS1
    $code2.text = ""
})

[System.Windows.Forms.Label]$LabelS2 = @{
    Font = "Verdana, 11"
    Location = New-Object System.Drawing.Point(10,235)
    Size = New-Object System.Drawing.Size(600,25)
    AutoEllipsis = $true
    BackColor = "#101c28"
}
$panel.Controls.Add($LabelS2)


# Creazione script
[System.Windows.Forms.Button]$ButtonPS1 = @{
    Location = New-Object System.Drawing.Point(10,420)
    Size = New-Object System.Drawing.Size(120,30)
    Text = "CREATE PS1"
    Font = "Verdana, 11"
    BackColor = "#3a134a"
}
$main_form.Controls.Add($ButtonPS1)

[System.Windows.Forms.CheckBox]$CheckBoxP = @{
    Text = " Open 'carrier.ps1' file when it's completed"
    Font = "Verdana, 11"
    AutoSize = $true
    Location = New-Object System.Drawing.Point(373,425)
}
$main_form.Controls.Add($CheckBoxP)

[System.Windows.Forms.TextBox]$textBoxPS1 = @{
    Location = New-Object System.Drawing.Point(10,455)
    Size = New-Object System.Drawing.Size(720,80)
    Font = "Verdana, 12"
    BackColor = "#08243f"
    ForeColor = "#ffffff"
}
$main_form.Controls.Add($textBoxPS1)

$ButtonPS1.Add_Click({
    $textBoxPS1.Text = "Wait..."
    # Conversione immagine in Base64
    $imageBytes = [System.IO.File]::ReadAllBytes($ImgPath)
    $base64Im = [Convert]::ToBase64String($imageBytes)
    Start-Sleep 1
    if ("$($LabelSaveP.Text)" -eq "") {
        $textBoxPS1.Text = "File not created; check save path and chosen settings"
        return
    } elseif (("$($LabelSaveP.Text)" -eq "\carrier.ps1") -or ("$($LabelSaveP.Text)" -eq $null)) {
        $textBoxPS1.Text = "File not created; set a 'carrier.ps1' path and try again"
        return
    } else {
        if ($imP.text -or $teP.text) {
            if (([int]$($imP.text) + [int]$($teP.text)) -ne 100) {
                [System.Windows.Forms.MessageBox]::Show("The two section percentages are not correct: their sum must be 100", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
                $textBoxPS1.Text = ""
                return
            }            
        }
        # Creazione del file carrier.ps1
        $script = @"        
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Shell non visualizzata
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
'
`$consolePtr = [Console.Window]::GetConsoleWindow()
[Console.Window]::ShowWindow(`$consolePtr, 0)

# Impostazione Form principale
`$main_form = New-Object System.Windows.Forms.Form
`$main_form.Text ='WrapperShell'
`$main_form.Opacity = 0.95
`$main_form.Size = New-Object System.Drawing.Size("$(if ($winW.Text -ne "") { $winW.Text } else { "800" })","$(if ($winH.Text -ne "") { $winH.Text } else { "400" })")
`$main_form.BackColor = "$(if ($winC.Text -ne "") { $winC.Text } else { '#434c56' })"
`$main_form.ForeColor = "$(if ($winT.Text -ne "") { $winT.Text } else { '#ffffff' })"
`$main_form.StartPosition = "CenterScreen"
`$main_form.FormBorderStyle = "FixedSingle"
`$main_form.MaximizeBox = `$false
`$main_form.MinimizeBox = `$true

`$base64Image = "$($base64Im)"

# Rimozione eventiali spazi e capoversi dal codice base64
`$base64Image = `$base64Image.Replace("``r``n", "").Replace("``n", "").Replace(" ", "")

# Da Base64 a bytes
`$imageBytes = [Convert]::FromBase64String(`$base64Image)

# Creazione dello stream dal byte array
`$memoryStream = New-Object System.IO.MemoryStream
`$memoryStream.Write(`$imageBytes, 0, `$imageBytes.Length)
`$memoryStream.Seek(0, [System.IO.SeekOrigin]::Begin)

# Caricamento dell'immagine dallo stream
`$image = [System.Drawing.Image]::FromStream(`$memoryStream)

# Creazione TableLayoutPanel con due colonne
`$tableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
`$tableLayoutPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
`$tableLayoutPanel.ColumnCount = 2
`$tableLayoutPanel.RowCount = 1
`$tableLayoutPanel.ColumnStyles.Add([System.Windows.Forms.ColumnStyle]::new([System.Windows.Forms.SizeType]::Percent, "$(if ($imP.Text -ne "") { $imP.Text } else { "50" })"))
`$tableLayoutPanel.ColumnStyles.Add([System.Windows.Forms.ColumnStyle]::new([System.Windows.Forms.SizeType]::Percent, "$(if ($teP.Text -ne "") { $teP.Text } else { "50" })"))

# Creazione PictureBox per l'immagine
`$pictureBox = New-Object System.Windows.Forms.PictureBox
`$pictureBox.Image = `$image
`$pictureBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
`$pictureBox.Dock = [System.Windows.Forms.DockStyle]::Fill

# Aggiunta PictureBox nella colonna di sinistra di TableLayoutPanel
`$tableLayoutPanel.Controls.Add(`$pictureBox, 0, 0)

# Creazione del box per il testo
`$randomText = New-Object System.Windows.Forms.TextBox
`$randomText.BackColor = "$(if ($winC.Text -ne "") { $winC.Text } else { '#434c56' })"
`$randomText.ForeColor = "$(if ($winT.Text -ne "") { $winT.Text } else { '#ffffff' })"
`$randomText.Font = "Verdana, 12"
`$randomText.Multiline = `$true  # Enable multiline
`$randomText.ScrollBars = "$(if ($radioButton1.Checked) { 'Vertical'} else { 'None' })"
`$randomText.BorderStyle = [System.Windows.Forms.BorderStyle]::None
`$randomText.Dock = [System.Windows.Forms.DockStyle]::Fill
`$randomText.Text = @'
$($text.text)
'@

# Aggiunta Label con testo nella colonna destra di TableLayoutPanel
`$tableLayoutPanel.Controls.Add(`$randomText, 1, 0)

# Bottone 1
$(if ($box1.checked) {
@"
`$columnIndex = 0
`$columnStyle = `$tableLayoutPanel.ColumnStyles[`$columnIndex]
`$percentageW = `$columnStyle.Width
`$ww = `$main_form.Width
`$wh = `$main_form.Height
`$iw = [int]`$ww*(`$percentageW/100)
`$ih = [int]`$wh*(`$percentageW/100)
`$btn1r = `$iw+([int](`$ww-`$iw)*0.1)
`$btn1b = [int]`$wh*0.82
`$btn1w = (`$iw+([int](`$ww-`$iw)*0.4))-(`$iw+([int](`$ww-`$iw)*0.1))
`$btn1h = (`$wh-([int]`$wh*0.89))-(`$wh-([int]`$wh*0.95))

# Creazione bottone 1
[System.Windows.Forms.Button]`$ButtonOK = @{
    Location = New-Object System.Drawing.Point([int]`$btn1r,[int]`$btn1b)
    Size = New-Object System.Drawing.Size([int]`$btn1w,`[int]`$btn1h)
    Text = "$(if ($b1tx.Text -ne "") { $b1tx.Text })"
    Font = "Verdana, 10"
    BackColor = "$(if ($b1b.Text -ne "") { $b1b.Text } else { "#3a134a" })"
    ForeColor = "$(if ($b1T.Text -ne "") { $b1t.Text } else { "#ffffff" })"
}
`$main_form.Controls.Add(`$ButtonOK)
`$ButtonOK.BringToFront()

`$ButtonOK.Add_Click({
    $(if (($code1.text -eq "") -and $1PS1File) {
        $exec1 = Get-Content -Path $1PS1File -Raw
    } else {
        $exec1 = $($code1.text)
    })
    `$run1 = '$($exec1)'
    `$process = Start-Process powershell -ArgumentList "-Command", `$run1 -PassThru
})
"@})

# Bottone 2
$(if ($box2.checked) {
@"
`$columnIndex = 0
`$columnStyle = `$tableLayoutPanel.ColumnStyles[`$columnIndex]
`$percentageW = `$columnStyle.Width
`$ww = `$main_form.Width
`$wh = `$main_form.Height
`$iw = [int]`$ww*(`$percentageW/100)
`$ih = [int]`$wh*(`$percentageW/100)
`$btn2r = `$iw+([int](`$ww-`$iw)*0.6)
`$btn2b = [int]`$wh*0.82
`$btn2w = (`$iw+([int](`$ww-`$iw)*0.9))-(`$iw+([int](`$ww-`$iw)*0.6))
`$btn2h = (`$wh-([int]`$wh*0.89))-(`$wh-([int]`$wh*0.95))

# Creazione bottone 2
[System.Windows.Forms.Button]`$ButtonCanc = @{
    Location = New-Object System.Drawing.Point([int]`$btn2r,[int]`$btn2b)
    Size = New-Object System.Drawing.Size([int]`$btn2w,[int]`$btn2h)
    Text = "$(if ($b2tx.Text -ne "") { $b2tx.Text })"
    Font = "Verdana, 10"
    BackColor = "$(if ($b2b.Text -ne "") { $b2b.Text } else { "#101c28" })"
    ForeColor = "$(if ($b2T.Text -ne "") { $b2t.Text } else { "#ffffff" })"
}
`$main_form.Controls.Add(`$ButtonCanc)
`$ButtonCanc.BringToFront()

`$ButtonCanc.Add_Click({
    $(if (($code2.text -eq "") -and $2PS1File) {
        $exec2 = Get-Content -Path $2PS1File -Raw
    } else {
        $exec2 = $($code2.text)
    })
    `$run2 = '$($exec2)'
    `$process = Start-Process powershell -ArgumentList "-Command", `$run2 -PassThru
})
"@})

# Aggiunta TableLayoutPanel al Form
`$main_form.Controls.Add(`$tableLayoutPanel)

# Impostazione autodistruzione
$(if ($CheckBoxD.Checked) {
"Start-Sleep `$stext.text
`$currentScriptPath = `$MyInvocation.MyCommand.Path
Remove-Item -Path `$currentScriptPath -Force"
})

`$main_form.Add_Load({
    # Set focus to the TextBox
    `$randomText.Focus()
    
    # Deselect the text by setting the selection start and length to 0
    `$randomText.SelectionStart = `$randomText.Text.Length
    `$randomText.SelectionLength = 0
})

# Visualizzazione Form
`$main_form.Add_Shown({`$main_form.Activate()})
[void]`$main_form.ShowDialog()

# Svuotamento risorse
`$main_form.Dispose()
"@
    }
    if ($CheckBoxS.Checked) {
        if ($ptext.TextLength -le 6) {
            [System.Windows.Forms.MessageBox]::Show("Password must have at least 6 characters", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
            $textBoxPS1.Text = ""
            return
        } else {
            # Funzione cifratura testo con AES
            function Encrypt-Text {
                param (
                    [string]$plainText,
                    [string]$key
                )
            
                # Creazione di un oggetto AES
                $aes = [System.Security.Cryptography.Aes]::Create()
                $sha512 = New-Object System.Security.Cryptography.SHA512Managed
                $keyBytes = $sha512.ComputeHash([Text.Encoding]::UTF8.GetBytes($key))
                $aes.Key = $keyBytes[0..31]  # Primi 32 byte per chiave AES-256
                $aes.GenerateIV() # Generazione IV
            
                $encryptor = $aes.CreateEncryptor($aes.Key, $aes.IV)
            
                # Cifratura testo
                $ms = New-Object IO.MemoryStream
                $cs = New-Object Security.Cryptography.CryptoStream($ms, $encryptor, [Security.Cryptography.CryptoStreamMode]::Write)
                $writer = New-Object IO.StreamWriter($cs)
                $writer.Write($plainText)
                $writer.Close()
                $encrypted = $ms.ToArray()
            
                # IV e testo cifrato come Base64
                return [Convert]::ToBase64String($aes.IV) + ":" + [Convert]::ToBase64String($encrypted)
            }
            
            $p0 = "$($ptext.Text)"
            $p1 = Get-FileHash -Algorithm SHA384 -InputStream ([IO.MemoryStream]::new([Text.Encoding]::UTF8.GetBytes($p0.substring(2,5)))) | ForEach-Object Hash
            $p2 = $p1.substring(5,42)
            $keyP = Get-FileHash -Algorithm SHA512 -InputStream ([IO.MemoryStream]::new([Text.Encoding]::UTF8.GetBytes($p2))) | ForEach-Object Hash
                        

            # Cifratura testo
            $encryptedText = Encrypt-Text -plainText $script -key $ptext.Text
            
            $decryp = @"
function Decrypt-Text {
param (
    [string]`$cipherText,
    [string]`$key
)

# Separazione IV e testo cifrato
`$parts = `$cipherText -split ":"
`$iv = [Convert]::FromBase64String(`$parts[0])
`$encrypted = [Convert]::FromBase64String(`$parts[1])

# Creazione nuovo oggetto AES
`$aes = [System.Security.Cryptography.Aes]::Create()
`$sha512 = New-Object System.Security.Cryptography.SHA512Managed
`$keyBytes = `$sha512.ComputeHash([Text.Encoding]::UTF8.GetBytes(`$key))
`$aes.Key = `$keyBytes[0..31]
`$aes.IV = `$iv

`$decryptor = `$aes.CreateDecryptor(`$aes.Key, `$iv)

`$ms = [System.IO.MemoryStream]::new(`$encrypted)
`$cs = [System.Security.Cryptography.CryptoStream]::new(`$ms, `$decryptor, [System.Security.Cryptography.CryptoStreamMode]::Read)

# Lettura testo cifrato
`$reader = [System.IO.StreamReader]::new(`$cs)
`$decryptedText = `$reader.ReadToEnd()

# Pulizia memoria
`$reader.Close()
`$cs.Close()
`$ms.Close()

return `$decryptedText
}

`$encrypted = "$encryptedText"

# Form richiesta password
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

`$form = New-Object System.Windows.Forms.Form
`$form.Text = "I N S E R T   P A S S W O R D"
`$form.Size = New-Object System.Drawing.Size(300,150)
`$form.BackColor = "#434c56"
`$form.ForeColor = "#ffffff"
`$form.StartPosition = "CenterScreen"
`$form.TopMost = `$true
`$form.ControlBox = `$false
`$form.FormBorderStyle = "FixedSingle"

`$passwordTextBox = New-Object System.Windows.Forms.TextBox
`$passwordTextBox.Location = New-Object System.Drawing.Point(12,30)
`$passwordTextBox.Size = New-Object System.Drawing.Size(260,30)
`$passwordTextBox.PasswordChar = [char]"*"
`$passwordTextBox.Font = "Verdana, 12"
`
`$submitButton = New-Object System.Windows.Forms.Button
`$submitButton.Text = "SUBMIT"
`$submitButton.Font = "Verdana, 11"
`$submitButton.Location = New-Object System.Drawing.Point(80,80)
`$submitButton.Size = New-Object System.Drawing.Size(140,25)
`$submitButton.BackColor = "#268ab6"
`$submitButton.DialogResult = [System.Windows.Forms.DialogResult]::OK

`$submitButton.Add_Click({
    `$password = `$passwordTextBox.Text
    if (`$password -eq "") {
        [System.Windows.Forms.MessageBox]::Show("Insert a password", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        Stop-Process -Id `$PID
    } else {
        `$global:password = `$passwordTextBox.Text
        `$form.Close()
    }
})

`$form.Controls.Add(`$passwordTextBox)
`$form.Controls.Add(`$submitButton)

# Visualizzazione Form
`$form.Add_Shown({`$form.Activate()})
[void]`$form.ShowDialog()

# Decifra testo se chiave corrisponde
`$ps1 = Get-FileHash -Algorithm SHA384 -InputStream ([IO.MemoryStream]::new([Text.Encoding]::UTF8.GetBytes(`$password.substring(2,5)))) | ForEach-Object Hash
`$ps2 = `$ps1.substring(5,42)
`$ps3 = Get-FileHash -Algorithm SHA512 -InputStream ([IO.MemoryStream]::new([Text.Encoding]::UTF8.GetBytes("`$(`$ps2)"))) | ForEach-Object Hash
if ("`$(`$ps3)" -eq "$($keyP)") {
    `$decryptedText = Decrypt-Text -cipherText `$encrypted -key `$password
    Invoke-Expression `$decryptedText
} else {
    # Finestra password errata
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    `$main_form = New-Object System.Windows.Forms.Form
    `$main_form.Text ='WRONG PASSWORD'
    `$main_form.Opacity = 0.95
    `$main_form.Size = New-Object System.Drawing.Size(330,250)
    `$main_form.BackColor = "#434c56"
    `$main_form.ForeColor = "#ffffff"
    `$main_form.StartPosition = "CenterScreen"
    `$main_form.TopMost = `$true
    `$main_form.FormBorderStyle = "FixedSingle"
    
    `$base64Image = "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"
   
    `$imageBytes = [Convert]::FromBase64String(`$base64Image)
    
    `$memoryStream = New-Object System.IO.MemoryStream
    `$memoryStream.Write(`$imageBytes, 0, `$imageBytes.Length)
    `$memoryStream.Seek(0, [System.IO.SeekOrigin]::Begin)
    
    `$image = [System.Drawing.Image]::FromStream(`$memoryStream)

    `$pictureBox = New-Object System.Windows.Forms.PictureBox
    `$pictureBox.Image = `$image
    `$pictureBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::StretchImage
    `$pictureBox.Dock = [System.Windows.Forms.DockStyle]::Fill
    `$pictureBox.Size = New-Object System.Drawing.Size(330,250)
    `$main_form.Controls.Add(`$pictureBox)
    
    `$main_form.Add_Shown({`$main_form.Activate()})
    [void]`$main_form.ShowDialog()
    
    `$main_form.Dispose()
}
            
"@
        }    
    } else {
        $decryp = $script
    }
    $decryp > "$($LabelSaveP.Text)"
    Start-Sleep 1
    if (Test-Path "$($LabelSaveP.Text)") {
        $textBoxPS1.Text = "File 'carrier.ps1' saved"
        # Apertura del file, se selezionata checkbox
        if ($CheckBoxP.Checked -and $CheckBoxS.Checked) {
            $textBoxPS1.Text = "File created; if the password is correct, wait for it to be deciphered and opened"
            & "$($LabelSaveP.Text)"
        } elseif ($CheckBoxP.Checked) {
            $textBoxPS1.Text = "File 'carrier.ps1' saved; wait for it to open or check for errors"
            & "$($LabelSaveP.Text)"
        }
    }
})

# Visualizzazione Form
$main_form.Add_Shown({$main_form.Activate()})
[void]$main_form.ShowDialog()

# Svuotamento risorse
$main_form.Dispose()