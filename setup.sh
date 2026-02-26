#!/bin/bash
# Claude Code 定期セッション セットアップスクリプト
# 使い方: bash setup.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_SCRIPTS_DIR="$HOME/.claude/scripts"
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"
LOG_DIR="$HOME/.claude/logs/scheduled"
PLIST_NAME="com.claude.scheduled-session"

echo "=== Claude Code 定期セッション セットアップ ==="

# Claude Code の存在確認
CLAUDE_PATH=$(which claude 2>/dev/null || true)
if [ -z "$CLAUDE_PATH" ]; then
    echo "エラー: Claude Code が見つかりません。先にインストールしてください。"
    exit 1
fi
echo "Claude Code: $CLAUDE_PATH"

# ディレクトリ作成
mkdir -p "$CLAUDE_SCRIPTS_DIR" "$LOG_DIR"

# スクリプトをコピー
cp "$SCRIPT_DIR/scheduled-session.sh" "$CLAUDE_SCRIPTS_DIR/scheduled-session.sh"
chmod +x "$CLAUDE_SCRIPTS_DIR/scheduled-session.sh"
echo "スクリプトを配置: $CLAUDE_SCRIPTS_DIR/scheduled-session.sh"

# plist 内のパスを環境に合わせて書き換え
sed "s|/Users/ykaneko|$HOME|g; s|/opt/homebrew/bin/claude|$CLAUDE_PATH|g" \
    "$SCRIPT_DIR/com.claude.scheduled-session.plist" > "$LAUNCH_AGENTS_DIR/$PLIST_NAME.plist"
echo "plist を配置: $LAUNCH_AGENTS_DIR/$PLIST_NAME.plist"

# スクリプト内の claude パスも書き換え
sed -i '' "s|/opt/homebrew/bin/claude|$CLAUDE_PATH|g" "$CLAUDE_SCRIPTS_DIR/scheduled-session.sh"

# 既存のジョブがあればアンロード
launchctl list | grep -q "$PLIST_NAME" && launchctl unload "$LAUNCH_AGENTS_DIR/$PLIST_NAME.plist" 2>/dev/null || true

# ロード
launchctl load "$LAUNCH_AGENTS_DIR/$PLIST_NAME.plist"
echo "launchd に登録完了"

# 確認
if launchctl list | grep -q "$PLIST_NAME"; then
    echo ""
    echo "=== セットアップ完了 ==="
    echo "実行スケジュール: 毎日 6:00 / 11:00 / 16:00 / 21:00 (JST)"
    echo "ログ: $LOG_DIR/"
    echo ""
    echo "手動テスト: bash $CLAUDE_SCRIPTS_DIR/scheduled-session.sh"
    echo "停止: launchctl unload $LAUNCH_AGENTS_DIR/$PLIST_NAME.plist"
else
    echo "エラー: launchd への登録に失敗しました"
    exit 1
fi
