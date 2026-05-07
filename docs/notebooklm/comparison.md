# notebooklm-mcp vs notebooklm-py 比較

| 観点 | notebooklm-mcp | notebooklm-py |
| --- | --- | --- |
| 種別 | MCP サーバ（Node.js） | Python ライブラリ / Skill |
| インストール | `codex mcp add notebooklm npx notebooklm-mcp@latest` | `pip install notebooklm-py` + Skill 登録 |
| Codex 統合 | ネイティブ（`codex mcp add` 一発） | Skill 経由（ラッパー必要） |
| Claude Code 統合 | ネイティブ（`claude mcp add`） | Skill 経由 |
| ランタイム | Node.js 18+ | Python 3.10+ |
| ブラウザ自動化 | Playwright（同梱） | Playwright（同梱） |
| ツール群 | `ask_question` / `add_source` / `generate_audio` / `list_notebooks` / `select_notebook` ほか | 同等 API を Python 関数として提供 |
| セッション永続化 | あり（FR-007 を満たす） | あり |
| 複数ノートブック同時管理 | ◎ | ○（自前で状態管理） |
| Windows 文字化け | 影響少（Node 側で UTF-8） | **要対策**（§8.2 / FR-008） |
| 拡張性 | MCP 仕様準拠で他クライアントから再利用可 | Python の自由度が高くカスタム処理を挟みやすい |
| デバッグ | MCP ログ＋ブラウザヘッド表示 | Python トレースバックで追いやすい |
| 学習コスト | 低（コマンド 1 行） | 中（ラッパーコード必要） |

## 推奨: **notebooklm-mcp（Primary）**

### 判断根拠

1. **設定コストが最小** — `codex mcp add` 1 行で完結し、§6.1 の推奨経路と一致。
2. **複数クライアント横展開** — MCP 標準なので Codex / Claude Code / Cursor から同じサーバを共有でき、§9 の X 実践報告とも整合。
3. **Windows 文字化けの影響を受けにくい** — §8.2 の Windows 特有問題は Python パイプ時に発生しやすく、Node.js の MCP サーバ経由なら回避できる。
4. **FR-006 / FR-007 の充足度が高い** — `codex mcp add` でツール呼び出しが標準化され、ノートブック切替・永続セッションが箱出しで動く。

## こちらを選ぶケース → notebooklm-py

- **Python 主体のパイプラインに組み込みたい**（既存のクオンツ / 研究コードと混ぜる）
- **回答後処理を Python で重く行いたい**（pandas でテーブル化・LangChain と接続など）
- **MCP を導入できない CI / 制約環境**

要件定義書 §3.1 の「notebooklm-py は無茶いい。Codex に丸投げで完璧に動いた」という X 実践者の声は、このユースケースに該当する。
