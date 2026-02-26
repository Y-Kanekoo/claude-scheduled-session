# claude-scheduled-session

macOS の launchd を使って Claude Code のセッションを定期的に自動開始するツール。

## スケジュール

毎日以下の時刻（JST）にセッションを開始:

| 時刻 | 説明 |
|------|------|
| 06:00 | 朝 |
| 11:00 | 昼前 |
| 16:00 | 夕方 |
| 21:00 | 夜 |

## 必要なもの

- macOS
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) (認証済み)

## セットアップ

```bash
git clone https://github.com/Y-Kanekoo/claude-scheduled-session.git
cd claude-scheduled-session
bash setup.sh
```

## アンインストール

```bash
bash uninstall.sh
```

## ファイル構成

| ファイル | 説明 |
|---------|------|
| `scheduled-session.sh` | セッション起動スクリプト |
| `com.claude.scheduled-session.plist` | launchd 設定 |
| `setup.sh` | セットアップスクリプト |
| `uninstall.sh` | アンインストールスクリプト |

## ログ

実行ログは `~/.claude/logs/scheduled/` に保存されます。30日以上前のログは自動削除されます。

## カスタマイズ

### スケジュール変更

`com.claude.scheduled-session.plist` の `StartCalendarInterval` を編集後、再セットアップ:

```bash
bash setup.sh
```

### プロンプト変更

`scheduled-session.sh` 内の `-p` オプションの引数を編集してください。

## 注意事項

- Mac がシャットダウン中は実行されません（スリープ中なら復帰後に実行）
- OAuth トークンが期限切れの場合は `claude` を手動で一度起動して再認証してください
