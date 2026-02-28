# claude-scheduled-session

Claude Code Max Plan の **5時間レート制限ウィンドウ** を自動管理するツール。

GitHub Actions で5時間間隔でセッションを自動開始し、ウィンドウのリセットタイミングを制御する。追加の API 課金は発生しない（Max Plan サブスク内で動作）。

## 背景

Max Plan のレート制限は **5時間ローリングウィンドウ** で管理されている。

- ウィンドウは **最初のメッセージ送信時** に開始される
- 5時間経過すると使用量がリセットされ、新しいウィンドウが始まる
- 手動でタイミングを管理するのは面倒 → **自動化で解決**

## スケジュール

5時間間隔で1日4回、セッションを自動開始:

| 時刻 (JST) | ウィンドウ |
|-------------|-----------|
| 06:00 | 06:00 〜 11:00 |
| 11:00 | 11:00 〜 16:00 |
| 16:00 | 16:00 〜 21:00 |
| 21:00 | 21:00 〜 02:00 |

> **注**: GitHub Actions の cron には数十分〜最大2時間程度の遅延が発生します。この遅延が自然なバッファとなり、前のウィンドウ終了後にセッションが開始されるケースがほとんどです。

## セットアップ

### 1. リポジトリを Fork

このリポジトリを自分のアカウントに Fork する。

### 2. OAuth トークンを生成

```bash
claude setup-token
```

ブラウザが開くので、Claude.ai アカウントで認証する。表示されたトークン（`sk-ant-oat01-...`）をコピー。

### 3. GitHub Secrets に登録

Fork したリポジトリの **Settings > Secrets and variables > Actions** で以下を設定:

| Secret 名 | 値 |
|-----------|-----|
| `CLAUDE_CODE_OAUTH_TOKEN` | 手順2で生成したトークン |

CLI で登録する場合:

```bash
gh secret set CLAUDE_CODE_OAUTH_TOKEN -R <ユーザー名>/claude-scheduled-session
```

### 4. 完了

自動でスケジュール実行される。

手動テスト: Actions タブ > "Claude Code Scheduled Session" > "Run workflow"

## スケジュールのカスタマイズ

`.github/workflows/scheduled-session.yml` の `cron` を編集:

```yaml
schedule:
  # JST = UTC + 9（5時間間隔）
  - cron: '0 21 * * *'  # 06:00 JST
  - cron: '0 2 * * *'   # 11:00 JST
  - cron: '0 7 * * *'   # 16:00 JST
  - cron: '0 12 * * *'  # 21:00 JST
```

## セキュリティ

| 観点 | 説明 |
|------|------|
| **トークン保管** | GitHub Secrets で暗号化保存。ログでも自動マスクされる |
| **Fork からの実行** | `schedule` はデフォルトブランチでのみ実行。Fork からは発火しない |
| **トークン漏洩時の影響** | セッション枠の消費のみ。金銭的被害なし（定額サブスク） |
| **対処** | `claude setup-token` で再生成すれば旧トークンは無効化される |

## メンテナンス

| 項目 | 頻度 | 方法 |
|------|------|------|
| **トークン更新** | 約1年に1回 | `claude setup-token` → GitHub Secrets を更新 |
| **ログ確認** | 任意 | GitHub Actions タブで実行履歴を確認 |

## 注意事項

- Max Plan には5時間ウィンドウの他に、**週次・月次の使用量上限**もある
- GitHub Actions のスケジュールはリポジトリが60日間非アクティブだと自動停止される（適宜コミットで維持）
