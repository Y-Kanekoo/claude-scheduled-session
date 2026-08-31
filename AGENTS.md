# AIエージェント共通運用

このファイルを、CodexとClaude Codeが共有するリポジトリ運用ルールの正本とする。
共通ルールを変更するときはこのファイルだけを編集し、`CLAUDE.md`へ重複記載しない。

## リポジトリの目的

- GitHub ActionsからCodexまたはClaude Codeを定期実行する。
- 実行プロバイダーはワークフローを変更せず、Repository Variableで切り替える。
- 認証情報はRepository Secretだけに保存する。

## 恒久設定の保存場所

- 共通の開発・運用ルール: `AGENTS.md`
- Claude Code用の入口: `CLAUDE.md`（`AGENTS.md`を読み込むだけにする）
- 実行プロバイダー: Repository Variable `AI_PROVIDER`
- 定期実行プロンプト: Repository Variable `AI_PROMPT`
- 認証情報: Repository Secret `OPENAI_API_KEY`または`ANTHROPIC_API_KEY`
- 実行時刻・権限・具体的な処理: `.github/workflows/scheduled-session.yml`
- 人向けの設定手順: `README.md`

## 変更時のルール

- `AI_PROVIDER`は`auto`、`codex`、`claude`だけを受け付ける。
- `auto`は`OPENAI_API_KEY`、次に`ANTHROPIC_API_KEY`の存在順で選択する。
- GitHub Actionsの権限は必要最小限に保ち、通常は`contents: read`とする。
- Codexは`openai/codex-action@v1`を`read-only` sandboxで使用する。
- APIキー、トークン、個人情報をリポジトリ、ログ、`.env`へ書かない。
- 実行時刻、Secret名、Variable名を変えた場合は`README.md`と`SETUP_PROMPT.md`も同時に更新する。
- 変更後はワークフロー構文を検証し、可能なら手動実行で対象プロバイダーを確認する。

