# セットアップ用プロンプト

以下をAIコーディングエージェントへ渡すときの共通仕様。

```text
Claude CodeまたはCodexをGitHub Actionsから定期実行できるワークフローを保守してください。

要件:
- 定期実行は06:11 / 11:11 / 16:11 / 21:11 JST
- Repository Variable `AI_PROVIDER`で`auto` / `codex` / `claude`を切り替える
- `auto`は`OPENAI_API_KEY`、次に`ANTHROPIC_API_KEY`の存在順で選ぶ
- Repository Variable `AI_PROMPT`で指示文を変更できる
- Codexは公式`openai/codex-action@v1`を`read-only` sandboxで使う
- Claude Codeは`ANTHROPIC_API_KEY`で非対話実行する
- 認証情報はGitHub Secrets以外へ保存しない
- GitHub権限は`contents: read`に限定する
- 手動実行ではプロバイダーを一時的に上書きできる
- Secret不足や未知のプロバイダーは、原因を明示して失敗させる

設定場所とCLI:
- GitHub: Settings > Secrets and variables > Actions
- `gh secret set OPENAI_API_KEY -R <owner>/<repo>`
- `gh secret set ANTHROPIC_API_KEY -R <owner>/<repo>`
- `gh variable set AI_PROVIDER --body auto -R <owner>/<repo>`
- `gh variable set AI_PROMPT --body "Respond with a short health-check message." -R <owner>/<repo>`
```
