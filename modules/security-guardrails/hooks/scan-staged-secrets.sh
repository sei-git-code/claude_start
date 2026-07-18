#!/usr/bin/env bash
# PostToolUse hook: git add/commit 後にステージング済み内容へ機密情報が含まれていないか警告する
# PostToolUse はすでに実行済みのため exit 2 は効かない。警告のみ。
# 元記事: https://qiita.com/nogataka/items/bab35c7b58a664d3b8f1

INPUT=$(cat)
COMMAND=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // empty')

echo "$COMMAND" | grep -qE 'git[[:space:]]+(add|commit)' || exit 0

STAGED_DIFF=$(git diff --cached 2>/dev/null)
[ -z "$STAGED_DIFF" ] && exit 0

SECRET_PATTERNS=(
  'AKIA[0-9A-Z]{16}'
  'sk-[a-zA-Z0-9]{32,}'
  'ghp_[a-zA-Z0-9]{36}'
  'xoxb-[0-9a-zA-Z-]+'
  'Bearer[[:space:]]+[a-zA-Z0-9._-]{20,}'
  'password[[:space:]]*=[[:space:]]*[^$'"'"'"\n]{8,}'
  'secret[[:space:]]*=[[:space:]]*[^$'"'"'"\n]{8,}'
  'api_key[[:space:]]*=[[:space:]]*[^$'"'"'"\n]{8,}'
)

FOUND=false
for PATTERN in "${SECRET_PATTERNS[@]}"; do
  if echo "$STAGED_DIFF" | grep -qiE "$PATTERN"; then
    echo "SecretScan: 警告 — ステージング済みファイルに機密情報の可能性があるパターンを検出しました" >&2
    echo "SecretScan: パターン: $PATTERN" >&2
    echo "SecretScan: git reset HEAD <ファイル名> でアンステージしてから確認してください" >&2
    FOUND=true
  fi
done

LOG_DIR="${HOME}/.claude/logs"
mkdir -p "$LOG_DIR"
if [ "$FOUND" = true ]; then
  echo "$(date -Iseconds) [SECRET_WARNING] コマンド: $COMMAND" >> "${LOG_DIR}/guardrail-$(date +%Y-%m-%d).log"
  exit 1
fi

exit 0
