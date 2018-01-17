$directions=@("192.168.0.1","192.168.2.1","192.168.2.3")
$er_directions=@()

foreach($d in $directions) {
    try {
        Test-Connection -Count 1 $d -ErrorAction Stop
        continue
    } catch {
        $er_directions += $d
    }
}

if($er_directions.Length==0) { exit 0 }
# Test-Connection に失敗したとき、下記処理へ進む

# ビープ音開始
Start-Job -Name "JobBeep" {
    while ($True){
        [Console]::Beep(1760,600)
        Start-Sleep -m 200
    }
}

# アセンブリのロード
Add-Type -AssemblyName System.Windows.Forms

# フォーム
$form = New-Object System.Windows.Forms.Form
$form.Size = "250,200"
$form.startposition = "centerscreen"
$form.text = "警告"
$form.MaximizeBox = $false
$form.MinimizeBox = $false

# ラベル
$Label = New-Object System.Windows.Forms.Label
$Label.Location = "20,20"
$Label.Text = "サーバからの応答がありません。`r`n" + [string]::Join("`r`n", $er_directions)
$Label.BackColor = "#FFFF00"
$Label.AutoSize = $True
$form.Controls.Add($Label)

# ボタン
$Button = New-Object System.Windows.Forms.Button
$Button.Location = "50,80"
$Button.size = "80,30"
$Button.text  =　"確認"
$Button.FlatStyle = "popup"
$form.Controls.Add($Button)

# クリックイベント
$Button.Add_Click({
    # ビープ音停止
    Stop-Job -Name JobBeep
    # ダイアログ閉
    $form.Close()
})

# フォームの表示
$form.Showdialog()
exit 1