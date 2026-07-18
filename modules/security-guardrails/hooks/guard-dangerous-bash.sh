#!/usr/bin/env bash
# PreToolUse hook: 危険な Bash コマンドを遮断する
# exit 2 を返すと Claude Code はそのツール呼び出しをキャンセルする
# 元記事: https://qiita.com/nogataka/items/bab35c7b58a664d3b8f1
# (元記事は python3 でJSONを解析していたが、この環境にはpython3の実体がないため jq に置き換え)

INPUT=$(cat)
COMMAND=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // empty')

[ -z "$COMMAND" ] && exit 0

LOG_DIR="${HOME}/.claude/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="${LOG_DIR}/guardrail-$(date +%Y-%m-%d).log"
log_event() {
  echo "$(date -Iseconds) [$1] $2" >> "$LOG_FILE"
}

DANGEROUS_PATTERNS=(
  'rm[[:space:]]+-[a-zA-Z]*r[a-zA-Z]*f'
  'rm[[:space:]]+-[a-zA-Z]*f[a-zA-Z]*r'
  'sudo[[:space:]]+rm'
  ':\(\)\{:\|:&\};:'
  'mkfs\.'
  'dd[[:space:]]+if='
  '>[[:space:]]*/dev/sd'
  'curl[^|]*\|[[:space:]]*(ba)?sh'
  'wget[^|]*\|[[:space:]]*(ba)?sh'
  'chmod[[:space:]]+777'
  'git[[:space:]]+push[[:space:]]+(-f|--force)'
)

for PATTERN in "${DANGEROUS_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qE "$PATTERN"; then
    echo "Guard: 危険なコマンドパターンを検出したため実行をブロックしました: $COMMAND" >&2
    echo "Guard: パターン: $PATTERN" >&2
    log_event "BLOCKED" "コマンド: $COMMAND / パターン: $PATTERN"
    exit 2
  fi
done

exit 0
