# Codex × NotebookLM 連携

要件定義書 v1.0（2026-05-05）に基づく実装ドキュメント。

| ファイル | 用途 |
| --- | --- |
| [`setup.md`](./setup.md) | Codex CLI からのセットアップ手順（コマンド全文） |
| [`comparison.md`](./comparison.md) | notebooklm-mcp vs notebooklm-py 比較と推奨 |
| [`windows-mojibake-fix.ps1`](./windows-mojibake-fix.ps1) | Windows 文字化け対策（PowerShell） |
| [`windows-mojibake-fix.sh`](./windows-mojibake-fix.sh) | macOS / Linux / WSL 用の同等スクリプト |
| [`prompt-templates.md`](./prompt-templates.md) | Codex 用プロンプトテンプレート（10 個） |
| [`roadmap.md`](./roadmap.md) | 将来的な拡張案（横断検索・自動ソース更新ほか） |

## 目的

- 大量ドキュメント分析を NotebookLM にオフロードし、Codex 側のトークンを 70% 以上削減
- ソース引用付き回答（FR-004）でハルシネーションを抑制
- 研究 → 実装のシームレスなワークフロー

## 参照

- notebooklm-mcp: https://github.com/PleasePrompto/notebooklm-mcp
- notebooklm-py: https://github.com/teng-lin/notebooklm-py
