# セットアップ手順

要件定義書 §6 の推奨構成（Codex CLI → notebooklm-mcp → NotebookLM）を最短で動かす手順。

## 0. 前提条件（§8.1）

- Codex CLI または Claude Code が利用可能
- Google アカウント（NotebookLM の利用権限あり）
- Node.js 18+（MCP 経路）または Python 3.10+（Skill 経路）
- Playwright / Chromium（MCP がブラウザ自動化に使用）

## 1. Primary 構成: notebooklm-mcp（推奨）

### 1.1 MCP サーバを Codex に登録

```bash
codex mcp add notebooklm npx notebooklm-mcp@latest
```

Claude Code で使う場合は同等に:

```bash
claude mcp add notebooklm -- npx -y notebooklm-mcp@latest
```

### 1.2 Playwright のブラウザを取得

```bash
npx playwright install chromium
```

### 1.3 Google 認証（初回のみ）

初回 `ask_question` 実行時にブラウザが開き、Google ログインを求められる。
セッションは永続化されるため、2 回目以降は自動。

```bash
codex
> NotebookLM の list_notebooks を呼んで、ノートブック一覧を表示して
```

### 1.4 動作確認

```bash
codex
> NotebookLM で "test" という名前のノートブックを作成し、
> https://example.com/sample.pdf をソースに登録して、
> "このドキュメントの要点を 3 行で" と質問して
```

回答に **citation（ソース引用）** が付いていれば成功（§5 品質要件）。

---

## 2. Alternative 構成: notebooklm-py（Python Skill）

Codex CLI に MCP を入れたくない・Python 環境で完結させたい場合。

### 2.1 インストール

```bash
pip install notebooklm-py
# または最新版
pip install git+https://github.com/teng-lin/notebooklm-py.git
playwright install chromium
```

### 2.2 Skill としての登録

`~/.codex/skills/notebooklm.py` に薄いラッパーを置き、`codex skill add` で登録。

```python
# ~/.codex/skills/notebooklm.py
from notebooklm import NotebookLM

nb = NotebookLM()  # 初回はブラウザログイン

def ask_question(notebook_id: str, question: str) -> dict:
    return nb.ask(notebook_id, question)

def add_source(notebook_id: str, url: str) -> dict:
    return nb.add_source(notebook_id, url)
```

### 2.3 Windows ユーザは先に文字化け対策

`./windows-mojibake-fix.ps1` を実行してから初回起動すること（§8.2、FR-008）。

---

## 3. トラブルシューティング

| 症状 | 対処 |
| --- | --- |
| 認証エラーが繰り返す | ブラウザのプロファイルディレクトリを削除して再認証（FR-008 の再認証フロー） |
| Windows で文字化け | `windows-mojibake-fix.ps1` を実行 |
| Playwright が起動しない | `npx playwright install --with-deps chromium` |
| `ask_question` がタイムアウト | NotebookLM 側のソース処理待ち。30〜60 秒後に再試行 |

## 4. アンインストール

```bash
codex mcp remove notebooklm
# Python Skill の場合
pip uninstall notebooklm-py
rm ~/.codex/skills/notebooklm.py
```
