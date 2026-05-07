# Codex 用プロンプトテンプレート集

要件定義書 §7 ユースケースに即した 10 個のテンプレート。`{{...}}` を埋めてそのまま Codex に貼り付ける想定。

---

## 1. 研究論文比較（UC1）

```
NotebookLM の `{{notebook_name}}` を select_notebook で選択し、
以下の論文を add_source で一括登録してから ask_question を呼んで:

ソース:
{{paper_url_1}}
{{paper_url_2}}
...

質問: 「主要なコントリビューションの違いを表形式で比較し、
各セルに citation を付けて返答せよ。」

回答を Markdown で出力し、引用元 URL を脚注として付けること。
```

## 2. 動画 → コード実装（UC2）

```
NotebookLM の `{{notebook_name}}` に YouTube URL `{{video_url}}` を
add_source で登録。文字起こしが完了したら ask_question で
「動画内で説明されているアルゴリズムの擬似コードを抽出して」
と質問。返ってきた擬似コードを Python に翻訳し、
{{repo_path}} に PR を作成して。テストは pytest で。
```

## 3. 書籍丸ごと活用（UC3）

```
NotebookLM `{{book_notebook}}` に登録済みの技術書から、
ask_question で「第 {{chapter}} 章のアルゴリズム X の前提条件と
入出力仕様を箇条書きで」と取得。citation 付きで返答させ、
それに従って `src/{{module}}/x.py` に実装。
ユニットテストも併せて生成。
```

## 4. クオンツ研究（UC4）

```
NotebookLM `{{quants_notebook}}` の最新論文から
「シグナル生成ロジックの数式と推奨パラメータ」を ask_question で抽出。
それを基に backtrader のストラテジ `strategies/{{name}}.py` を実装。
backtest 設定は configs/{{name}}.yaml で。
```

## 5. ハルシネーションチェック（FR-004）

```
直前に Codex が出した回答 `{{answer}}` の主張を 3 つに分解し、
各主張について NotebookLM `{{notebook_name}}` で
「この主張がソースで支持されているか citation を伴って答えよ」と
ask_question せよ。支持されない主張は赤字で警告として返答。
```

## 6. 複数ノートブック横断（→ §10 拡張案）

```
ノートブック {{nb_a}} / {{nb_b}} / {{nb_c}} に対して同じ質問
「{{question}}」を順に ask_question で投げ、
回答を Markdown 表に集約。各行末尾に citation。
最後に「3 つの回答の差分」を 5 行以内で要約。
```

## 7. ポッドキャスト生成 + 要約（FR-005）

```
NotebookLM `{{notebook_name}}` で generate_audio を呼び、
完了後に download_audio で `{{out_dir}}/podcast.mp3` に保存。
さらに ask_question で「Audio Overview の章立て構成を
タイムスタンプ付きで列挙」を取得し、podcast.md に併せて出力。
```

## 8. ソース一括登録（FR-003）

```
以下の混在リストを NotebookLM `{{notebook_name}}` に
add_source で順次登録（URL / PDF / YouTube / テキスト / Google Drive）。
失敗した行は再試行ロジック（最大 3 回・指数バックオフ）。
最終的に list_sources で全件リストアップして検証して。

{{paste_list_here}}
```

## 9. ノートブックの自動切替（FR-007）

```
タスクごとに対応する NotebookLM ノートブックを使い分けたい。
以下のマッピングを ~/.codex/notebook_map.json に保存し、
プロンプトの先頭ヒント `[nb:research]` 等で select_notebook を
自動呼び出しするフックを書いて。

{
  "research": "{{nb_research_id}}",
  "code":     "{{nb_code_id}}",
  "quants":   "{{nb_quants_id}}"
}
```

## 10. Windows 文字化け遭遇時の自己修復（FR-008）

```
直前の notebooklm-py 出力に文字化け（mojibake）が含まれていたら:
1. `docs/notebooklm/windows-mojibake-fix.ps1` を案内
2. PYTHONUTF8=1 / PYTHONIOENCODING=utf-8 を現プロセスに適用
3. 同じ ask_question を再実行
4. それでも mojibake なら chcp 65001 を確認するよう警告
を一連で実行する Codex プロシージャを実装。
```
