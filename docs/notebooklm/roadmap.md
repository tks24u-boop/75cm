# 拡張ロードマップ

要件定義書 §10 で求められた「将来的な拡張案」。優先度は v1 (近) → v3 (遠)。

## v1: 即時実装可能（〜1 週間）

### R-1. 複数ノートブック横断検索
- `ask_across(notebooks: list[str], question: str)` を MCP / Skill に追加
- 各ノートブックへの ask_question を並列実行（asyncio / Promise.all）
- 結果を統合し、citation を発出ノートブック ID で名前空間化

### R-2. 自動ソース更新
- `watch_source(url, interval)` で URL を定期チェック
- ETag / Last-Modified が変化したら add_source を再実行
- 旧版を別 ID で保持し、ask_question 時に diff 質問を可能に

### R-3. プロンプトヒント自動ルーティング
- プロンプト先頭の `[nb:research]` のようなタグから select_notebook を自動呼び出し
- §10 テンプレート 9 と接続

## v2: 中期（〜1 ヶ月）

### R-4. citation インライン展開
- ask_question の citation を Markdown フットノート ([^1]) に自動変換
- Codex の回答内に元ソースの該当箇所抜粋を注入

### R-5. キャッシュレイヤ
- 同一ノートブック × 同一質問のレスポンスをローカル DB に保存
- Codex のトークン削減目標 70%（§5）をさらに圧縮

### R-6. ノートブックのコード化（NotebookLM as Code）
- `notebooklm.yaml` でソース・パーミッションを宣言
- `codex notebooklm sync` で実体と同期（GitHub Actions 化）

### R-7. 認証エラー自己修復
- FR-008 の再認証フローを完全自動化
- セッション切れを検出 → ヘッドレスでブラウザ再ログイン → 元の ask_question を再試行

## v3: 長期（〜四半期）

### R-8. ソース信頼度スコア
- 引用元の発行元・日付・被引用数を集約しスコア化
- ask_question に `min_trust=0.7` のフィルタを追加

### R-9. 双方向同期（Codex ↔ NotebookLM）
- Codex の生成物（PR の要約・テスト結果）を Notebook の Note として書き戻し
- 「研究 → 実装 → 検証 → 研究」のループを単一履歴で追跡

### R-10. マルチユーザ・チーム共有
- MCP サーバを社内ホストし、複数ユーザで同一ノートブックセッションを共有
- 監査ログ・引用追跡を組織単位で

## 計測指標

| 指標 | 目標 | 計測方法 |
| --- | --- | --- |
| Codex トークン削減率 | ≥ 70%（§5） | NotebookLM 経由 / 非経由のトークン量比較 |
| 回答の citation 付与率 | 100%（FR-004） | ask_question レスポンスを集計 |
| 認証エラー自己回復率 | ≥ 95%（FR-008） | 再認証フローのログ |
| 横断検索の並列度 | N ノートブック並列で N×単発時間 ≤ 1.5 倍 | ベンチマーク |
