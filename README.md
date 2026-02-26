# claude-scheduled-session

Claude Code Max Plan の5時間レート制限ウィンドウを管理するツール。5時間間隔でセッションを自動開始し、ウィンドウのタイミングを制御する。

## 仕組み

Max Plan のレート制限は **5時間ローリングウィンドウ** で管理される。メッセージ送信がウィンドウの開始トリガーになるため、5時間ごとにセッションを開始することでウィンドウのリセットタイミングを制御できる。

## スケジュール

| 時刻 (JST) | ウィンドウ |
|-------------|-----------|
| 06:00 | 06:00 〜 11:00 |
| 11:00 | 11:00 〜 16:00 |
| 16:00 | 16:00 〜 21:00 |
| 21:00 | 21:00 〜 02:00 |

## セットアップ（GitHub Actions）

### 1. OAuth トークンを生成

```bash
claude setup-token
```

Max Plan のサブスク認証で動作するため、**API 課金は発生しない**。

### 2. GitHub Secrets に登録

リポジトリの Settings > Secrets and variables > Actions で以下を設定:

- `CLAUDE_CODE_OAUTH_TOKEN`: 手順1で生成したトークン

### 3. 完了

自動でスケジュール実行される。手動実行: Actions タブ > "Claude Code Scheduled Session" > "Run workflow"

## ファイル構成

| ファイル | 説明 |
|---------|------|
| `.github/workflows/scheduled-session.yml` | GitHub Actions ワークフロー |
| `scheduled-session.sh` | ローカル用セッション起動スクリプト (macOS launchd) |
| `com.claude.scheduled-session.plist` | launchd 設定 |
| `setup.sh` | ローカル用セットアップスクリプト |
| `uninstall.sh` | ローカル用アンインストールスクリプト |

## ローカル実行 (macOS launchd)

GitHub Actions の代わりに Mac のローカルで実行する場合:

```bash
git clone https://github.com/Y-Kanekoo/claude-scheduled-session.git
cd claude-scheduled-session
bash setup.sh
```

## 注意事項

- GitHub Actions のスケジュールは数分〜数十分の遅延が発生する場合がある
- OAuth トークンは有効期限があるため、期限切れ時は `claude setup-token` で再生成が必要
- Max Plan には月次・週次の使用量上限もあるため、過度な使用に注意
