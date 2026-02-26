#!/bin/bash
# Claude Code 定期セッション起動スクリプト
# 最小限のプロンプトでセッションを1ターンだけ実行する

LOG_DIR="$HOME/.claude/logs/scheduled"
mkdir -p "$LOG_DIR"

TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
LOG_FILE="$LOG_DIR/session_${TIMESTAMP}.log"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] セッション開始" >> "$LOG_FILE"

/opt/homebrew/bin/claude -p "現在時刻を教えてください" --max-turns 1 >> "$LOG_FILE" 2>&1
EXIT_CODE=$?

echo "[$(date '+%Y-%m-%d %H:%M:%S')] セッション終了 (exit: $EXIT_CODE)" >> "$LOG_FILE"

# 30日以上前のログを削除
find "$LOG_DIR" -name "session_*.log" -mtime +30 -delete 2>/dev/null
