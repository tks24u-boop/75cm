#!/usr/bin/env bash
# WSL / macOS / Linux 用の同等スクリプト。
# WSL から Python の notebooklm-py を呼ぶ場合の文字化け回避にも有効。
#
#   bash windows-mojibake-fix.sh
set -euo pipefail

RC_FILE="${HOME}/.bashrc"
[ -n "${ZSH_VERSION:-}" ] && RC_FILE="${HOME}/.zshrc"

MARKER='# >>> notebooklm utf-8 fix >>>'
END='# <<< notebooklm utf-8 fix <<<'

if grep -qF "$MARKER" "$RC_FILE" 2>/dev/null; then
  echo "既に適用済み: $RC_FILE"
else
  cat >> "$RC_FILE" <<EOF

$MARKER
export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8
export PYTHONUTF8=1
export PYTHONIOENCODING=utf-8
$END
EOF
  echo "追記しました: $RC_FILE"
fi

echo
echo '新しいシェルを開くか、以下で即時反映:'
echo "  source $RC_FILE"
