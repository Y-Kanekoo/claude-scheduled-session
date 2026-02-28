# セットアップ用プロンプト

以下を Claude Code に貼り付けて実行してください。

---

## プロンプト

```
Claude Code Max Plan の5時間レート制限ウィンドウを自動管理する GitHub Actions ワークフローを作成してください。

## 要件

- GitHub Actions で5時間間隔（6:00 / 11:00 / 16:00 / 21:00 JST）にセッションを自動開始する
- 認証は Max Plan の OAuth トークン（`claude setup-token` で生成）を使用し、API 課金は発生しない
- トークンは GitHub Secrets に `CLAUDE_CODE_OAUTH_TOKEN` として登録する
- 実行内容は `claude -p "hello" --max-turns 1` のみ（セッション開始がトリガー目的）
- リポジトリは public で作成

## 技術仕様

### ワークフロー (.github/workflows/scheduled-session.yml)

- cron スケジュール（JST = UTC + 9）:
  - `0 21 * * *` → 06:00 JST
  - `0 2 * * *`  → 11:00 JST
  - `0 7 * * *`  → 16:00 JST
  - `0 12 * * *` → 21:00 JST
- workflow_dispatch で手動実行も可能
- runs-on: ubuntu-latest
- timeout-minutes: 5
- npm install -g @anthropic-ai/claude-code でインストール
- 環境変数 CLAUDE_CODE_OAUTH_TOKEN を secrets から読み込み

## 手順

1. 新規リポジトリを作成（public）
2. ワークフローファイルと README.md を作成してプッシュ
3. `claude setup-token` は対話型のため手動実行が必要 → 手順を案内してください
4. `gh secret set CLAUDE_CODE_OAUTH_TOKEN -R <ユーザー名>/<リポジトリ名>` でトークンを登録
5. 手動テスト実行して成功を確認

## 注意事項

- GitHub Actions の cron には数十分〜最大2時間の遅延がある（ローリングウィンドウなので実害は小さい）
- トークンの有効期限は約1年。年1回 `claude setup-token` で再生成が必要
- GitHub Actions はリポジトリが60日間非アクティブだと自動停止される
```

---

## 既存リポジトリを Fork して使う場合

上のプロンプトの代わりに、以下の手順だけでOKです:

### 1. Fork

https://github.com/Y-Kanekoo/claude-scheduled-session を Fork

### 2. トークン生成

```bash
claude setup-token
```

### 3. GitHub Secrets に登録

```bash
gh secret set CLAUDE_CODE_OAUTH_TOKEN -R <自分のユーザー名>/claude-scheduled-session
```

### 4. 動作確認

```bash
gh workflow run scheduled-session.yml -R <自分のユーザー名>/claude-scheduled-session
```
