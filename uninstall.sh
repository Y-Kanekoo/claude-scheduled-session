#!/bin/bash
# Claude Code 定期セッション アンインストールスクリプト
# 使い方: bash uninstall.sh

PLIST_NAME="com.claude.scheduled-session"
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"
CLAUDE_SCRIPTS_DIR="$HOME/.claude/scripts"

echo "=== Claude Code 定期セッション アンインストール ==="

# launchd からアンロード
if launchctl list | grep -q "$PLIST_NAME"; then
    launchctl unload "$LAUNCH_AGENTS_DIR/$PLIST_NAME.plist"
    echo "launchd からアンロード完了"
fi

# ファイル削除
rm -f "$LAUNCH_AGENTS_DIR/$PLIST_NAME.plist"
rm -f "$CLAUDE_SCRIPTS_DIR/scheduled-session.sh"
echo "ファイルを削除しました"

echo ""
echo "=== アンインストール完了 ==="
echo "ログは残っています: $HOME/.claude/logs/scheduled/"
echo "ログも削除する場合: rm -rf $HOME/.claude/logs/scheduled/"
