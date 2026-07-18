#!/usr/bin/env bash
# PreToolUse hook: 不可逆・外部送信系の操作の前に y/N 確認を求める
# exit 2 で遮断、exit 0 で通過
# 元記事: https://qiita.com/nogataka/items/bab35c7b58a664d3b8f1

INPUT=$(cat)
COMMAND=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // empty')

[ -z "$COMMAND" ] && exit 0

LOG_DIR="${HOME}/.claude/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="${LOG_DIR}/guardrail-$(date +%Y-%m-%d).log"
log_event() {
  echo "$(date -Iseconds) [$1] $2" >> "$LOG_FILE"
}

CONFIRM_PATTERNS=(
  'git[[:space:]]+push'
  'git[[:space:]]+reset[[:space:]]+--hard'
  'git[[:space:]]+clean[[:space:]]+-f'
  'git[[:space:]]+stash[[:space:]]+drop'
  'npm[[:space:]]+publish'
  'docker[[:space:]]+push'
)

NEEDS_CONFIRM=false
for PATTERN in "${CONFIRM_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qE "$PATTERN"; then
    NEEDS_CONFIRM=true
    break
  fi
done

[ "$NEEDS_CONFIRM" = false ] && exit 0

# /dev/tty はパスとして存在しても実際には開けないことがある（このツール実行環境など、
# 制御端末を持たないプロセスの場合）。存在チェックだけでなく、実際の書き込みを試みて
# 失敗したら安全側に倒して確認なしで通す。エラー出力はこのブロックの間だけ抑制し、
# スクリプト全体のstderrには影響させない。
if ! exec 3>/dev/tty; then
  log_event "SKIPPED" "TTYオープン不可のため確認ゲートをスキップ: $COMMAND"
  exit 0
fi 2>/dev/null

{
  echo ""
  echo "=== Claude Code: 確認が必要な操作 ==="
  echo "コマンド: $COMMAND"
  echo ""
  printf "この操作を実行してよいですか？ [y/N]: "
} >&3

if ! read -r ANSWER <&3; then
  exec 3>&-
  log_event "SKIPPED" "TTY読み取り不可のため確認ゲートをスキップ: $COMMAND"
  exit 0
fi
exec 3>&-

if [[ "$ANSWER" =~ ^[Yy]$ ]]; then
  echo "Confirm: ユーザーが承認しました" >&2
  log_event "CONFIRMED" "$COMMAND"
  exit 0
else
  echo "Confirm: ユーザーがキャンセルしました" >&2
  log_event "CANCELLED" "$COMMAND"
  exit 2
fi
