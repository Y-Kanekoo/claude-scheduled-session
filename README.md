# claude-scheduled-session

Claude Code のセッションを定期的に自動開始するツール。GitHub Actions とローカル launchd の2方式に対応。

## スケジュール

毎日以下の時刻（JST）にセッションを開始:

| 時刻 | 説明 |
|------|------|
| 06:00 | 朝 |
| 11:00 | 昼前 |
| 16:00 | 夕方 |
| 21:00 | 夜 |

## 方式1: GitHub Actions（推奨）

### セットアップ

1. このリポジトリを Fork またはクローン
2. GitHub リポジトリの Settings > Secrets and variables > Actions で `ANTHROPIC_API_KEY` を設定
3. 自動でスケジュール実行される

手動実行: Actions タブ > "Claude Code Scheduled Session" > "Run workflow"

### 必要なもの

- GitHub アカウント
- Anthropic API Key (`ANTHROPIC_API_KEY`)

## 方式2: macOS launchd（ローカル）

### セットアップ

```bash
git clone https://github.com/Y-Kanekoo/claude-scheduled-session.git
cd claude-scheduled-session
bash setup.sh
```

### アンインストール

```bash
bash uninstall.sh
```

### 必要なもの

- macOS
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) (認証済み)

## ファイル構成

| ファイル | 説明 |
|---------|------|
| `.github/workflows/scheduled-session.yml` | GitHub Actions ワークフロー |
| `scheduled-session.sh` | ローカル用セッション起動スクリプト |
| `com.claude.scheduled-session.plist` | launchd 設定 |
| `setup.sh` | ローカル用セットアップスクリプト |
| `uninstall.sh` | ローカル用アンインストールスクリプト |

## ログ

- **GitHub Actions**: Actions タブから実行ログを確認
- **ローカル**: `~/.claude/logs/scheduled/` に保存（30日で自動削除）

## カスタマイズ

### スケジュール変更

- GitHub Actions: `.github/workflows/scheduled-session.yml` の `cron` を編集
- ローカル: `com.claude.scheduled-session.plist` の `StartCalendarInterval` を編集後 `bash setup.sh`

### プロンプト変更

各ファイル内の `-p` オプションの引数を編集してください。

## 注意事項

- GitHub Actions のスケジュール実行は数分〜数十分の遅延が発生する場合があります
- ローカル: Mac がシャットダウン中は実行されません（スリープ中なら復帰後に実行）
- ローカル: OAuth トークンが期限切れの場合は `claude` を手動で一度起動して再認証してください
