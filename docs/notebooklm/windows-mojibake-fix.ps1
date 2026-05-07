# Windows 文字化け対策 (§8.2 / FR-008)
# notebooklm-py 使用時に Windows で発生する文字化けを抑える。
# 使い方:
#   PowerShell を「管理者として実行」せずに開き、以下を実行:
#     Set-ExecutionPolicy -Scope Process Bypass
#     .\windows-mojibake-fix.ps1
#
# 効果:
#   - コンソール出力を UTF-8 (CP65001) に固定
#   - Python の標準入出力を UTF-8 に強制
#   - 現プロセスと PowerShell プロファイルの両方に適用

$ErrorActionPreference = 'Stop'

Write-Host '[1/4] コードページを UTF-8 (65001) に切替...' -ForegroundColor Cyan
chcp 65001 | Out-Null

Write-Host '[2/4] PowerShell の入出力エンコーディングを UTF-8 に...' -ForegroundColor Cyan
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
$OutputEncoding           = [System.Text.Encoding]::UTF8

Write-Host '[3/4] Python の UTF-8 モードを環境変数で有効化...' -ForegroundColor Cyan
[Environment]::SetEnvironmentVariable('PYTHONUTF8',        '1',     'User')
[Environment]::SetEnvironmentVariable('PYTHONIOENCODING',  'utf-8', 'User')
$env:PYTHONUTF8       = '1'
$env:PYTHONIOENCODING = 'utf-8'

Write-Host '[4/4] PowerShell プロファイルに永続化...' -ForegroundColor Cyan
$profilePath = $PROFILE.CurrentUserAllHosts
if (-not (Test-Path $profilePath)) {
    New-Item -ItemType File -Path $profilePath -Force | Out-Null
}

$marker  = '# >>> notebooklm utf-8 fix >>>'
$endMark = '# <<< notebooklm utf-8 fix <<<'
$block = @"
$marker
chcp 65001 > `$null
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
`$OutputEncoding           = [System.Text.Encoding]::UTF8
`$env:PYTHONUTF8       = '1'
`$env:PYTHONIOENCODING = 'utf-8'
$endMark
"@

$current = Get-Content -Raw -ErrorAction SilentlyContinue $profilePath
if ($current -notmatch [regex]::Escape($marker)) {
    Add-Content -Path $profilePath -Value "`n$block`n"
    Write-Host "  追記しました: $profilePath" -ForegroundColor Green
} else {
    Write-Host "  既に適用済み: $profilePath" -ForegroundColor Yellow
}

Write-Host ''
Write-Host '完了。新しい PowerShell ウィンドウを開いて以下で確認してください:' -ForegroundColor Green
Write-Host '  python -c "import sys; print(sys.stdout.encoding)"  # => utf-8'
Write-Host '  chcp                                                # => 65001'
