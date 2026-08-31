# AI Scheduled Session

Claude Code または Codex を GitHub Actions から定期実行する。プロバイダーはワークフローを書き換えずに、GitHub の Repository Variable で恒久的に切り替えられる。

## 実行時刻

毎日 06:11 / 11:11 / 16:11 / 21:11 JST に実行する。GitHub Actions の混雑を避けるため、毎時0分から11分へずらしている。

## 設定場所

リポジトリの **Settings > Secrets and variables > Actions** を開く。

### Secrets

利用するプロバイダーのキーだけを登録する。どちらも登録した場合、`auto` は Codex を優先する。

| Secret名 | 用途 |
|---|---|
| `OPENAI_API_KEY` | Codex用。OpenAI Platformで作成した専用APIキー |
| `ANTHROPIC_API_KEY` | Claude Code用。Anthropic Consoleで作成した専用APIキー |

CLIで登録する場合:

```bash
gh secret set OPENAI_API_KEY -R <ユーザー名>/claude-scheduled-session
gh secret set ANTHROPIC_API_KEY -R <ユーザー名>/claude-scheduled-session
```

キーはリポジトリや`.env`へ書かず、必ずGitHub Secretsへ登録する。各サービス側でこのワークフロー専用キーを発行し、利用上限を設定する。

### Variables

同じ画面の **Variables** タブで設定する。

| Variable名 | 値 | 説明 |
|---|---|---|
| `AI_PROVIDER` | `auto` / `codex` / `claude` | 定期実行で使うプロバイダー。未設定時は`auto` |
| `AI_PROMPT` | 任意の指示文 | 実行するプロンプト。未設定時は短いヘルスチェック |

推奨設定:

```bash
gh variable set AI_PROVIDER --body auto -R <ユーザー名>/claude-scheduled-session
gh variable set AI_PROMPT --body "Respond with a short health-check message." -R <ユーザー名>/claude-scheduled-session
```

`auto`の選択順は次のとおり。

1. `OPENAI_API_KEY`があればCodex
2. なければ`ANTHROPIC_API_KEY`でClaude Code
3. どちらもなければ、必要なSecret名を表示して安全に失敗

手動実行時は **Actions > AI Scheduled Session > Run workflow** の選択欄で、その1回だけ`auto` / `codex` / `claude`を上書きできる。

## CodexとClaude Codeの恒久指示

両方のエージェントへ同じルールを適用する場合は、リポジトリ直下の`AGENTS.md`へ書く。
`CLAUDE.md`は`@AGENTS.md`でその正本を読み込むため、共通ルールを二重管理しない。

設定の種類ごとの保存場所は次のとおり。

| 設定 | 保存場所 |
|---|---|
| 開発・運用ルール | `AGENTS.md` |
| Claude Codeだけの補足 | `CLAUDE.md` |
| プロバイダー選択 | Repository Variable `AI_PROVIDER` |
| 定期実行する指示文 | Repository Variable `AI_PROMPT` |
| APIキー | Repository Secrets |
| スケジュール・権限・実行処理 | `.github/workflows/scheduled-session.yml` |

個人だけに適用する設定はリポジトリへコミットせず、各ツールのユーザー設定へ置く。

## 認証と料金

GitHub-hosted runnerはブラウザ認証を引き継がないため、非対話CIではAPIキーを使用する。どちらも各APIの従量課金となり、ChatGPTまたはClaudeの個人向け定額契約枠とは別扱いになる。

- Codex: 公式の `openai/codex-action@v1` を使用し、`sandbox: read-only`で実行する
- Claude Code: `ANTHROPIC_API_KEY`を環境変数としてCLIへ渡す
- GitHub権限は`contents: read`のみ。チェックアウト時の認証情報も保持しない

## 保守

- APIキーは定期的にローテーションする
- 漏洩の疑いがあれば、各サービスの管理画面で直ちに無効化する
- 実行失敗時は最初の「プロバイダーと認証情報を確認」ステップを見る
- 60日間リポジトリ活動がない場合、GitHubがスケジュールを自動停止することがある

## 参考

- [Codex GitHub Action（OpenAI公式）](https://learn.chatgpt.com/docs/github-action)
- [Codexの認証（OpenAI公式）](https://learn.chatgpt.com/docs/auth)
- [Claude Codeのセットアップ（Anthropic公式）](https://docs.anthropic.com/en/docs/claude-code/getting-started)
