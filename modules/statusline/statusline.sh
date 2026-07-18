#!/usr/bin/env bash
# Claude Code status line
# Shows: model name | git branch | context usage gauge | 5h/7d rate-limit usage | session cost
# Managed by the "statusline-setup" agent. Ask Claude ("use the statusline-setup agent")
# to make further changes to this file.

input=$(cat)

# ---- colors (dim, for readability on dark/light terminals) ----
C_RESET='\033[0m'
C_MODEL='\033[2;36m'   # dim cyan
C_BRANCH='\033[2;32m'  # dim green
C_GAUGE='\033[2;33m'   # dim yellow
C_LIMIT='\033[2;35m'   # dim magenta
C_COST='\033[2;37m'    # dim white
C_LABEL='\033[2;90m'   # dim gray (separators)

# ---- model name ----
model=$(printf '%s' "$input" | jq -r '.model.display_name // .model.id // "unknown"')

# ---- git branch (skips optional locks so it never blocks other git processes) ----
cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // empty')
branch=""
if [ -n "$cwd" ] && [ -d "$cwd" ]; then
  branch=$(cd "$cwd" 2>/dev/null && git --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)
  [ "$branch" = "HEAD" ] && branch=$(cd "$cwd" 2>/dev/null && git --no-optional-locks rev-parse --short HEAD 2>/dev/null)
fi

# ---- context usage gauge ----
used_pct=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // empty')
gauge=""
if [ -n "$used_pct" ]; then
  pct_int=$(printf '%.0f' "$used_pct")
  filled=$(( pct_int / 10 ))
  [ "$filled" -gt 10 ] && filled=10
  [ "$filled" -lt 0 ] && filled=0
  empty=$(( 10 - filled ))
  bar=$(printf '%*s' "$filled" '' | tr ' ' '█')
  rest=$(printf '%*s' "$empty" '' | tr ' ' '░')
  gauge="[${bar}${rest}] ${pct_int}%"
fi

# ---- 5-hour / 7-day rate-limit usage (Claude.ai subscription limits) ----
five=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week=$(printf '%s' "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
limits=""
if [ -n "$five" ]; then
  limits="5h:$(printf '%.0f' "$five")%"
fi
if [ -n "$week" ]; then
  [ -n "$limits" ] && limits="$limits "
  limits="${limits}7d:$(printf '%.0f' "$week")%"
fi

# ---- cumulative session cost, computed from the transcript's token usage ----
# Pricing is per-1M-tokens and matched by model-id substring (opus / haiku / default-sonnet).
transcript=$(printf '%s' "$input" | jq -r '.transcript_path // empty')
cost=""
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
  cost_usd=$(jq -s '
    def price(m):
      if (m|test("opus";"i")) then {i:15, o:75, cw:18.75, cr:1.5}
      elif (m|test("haiku";"i")) then {i:0.8, o:4, cw:1, cr:0.08}
      else {i:3, o:15, cw:3.75, cr:0.3}
      end;
    [ .[] | select(.message.usage != null and .message.id != null) ]
    | unique_by(.message.id)
    | map(
        (.message.model // "unknown") as $m
        | .message.usage as $u
        | (price($m)) as $p
        | ((($u.input_tokens // 0) * $p.i)
          + (($u.output_tokens // 0) * $p.o)
          + (($u.cache_creation_input_tokens // 0) * $p.cw)
          + (($u.cache_read_input_tokens // 0) * $p.cr)) / 1000000
      )
    | add // 0
  ' "$transcript" 2>/dev/null)
  if [ -n "$cost_usd" ]; then
    cost=$(printf '$%.2f' "$cost_usd")
  fi
fi

# ---- assemble the line ----
line="${C_MODEL}${model}${C_RESET}"

if [ -n "$branch" ]; then
  line="${line} ${C_LABEL}|${C_RESET} ${C_BRANCH}⎇ ${branch}${C_RESET}"
fi

if [ -n "$gauge" ]; then
  line="${line} ${C_LABEL}|${C_RESET} ${C_GAUGE}Ctx ${gauge}${C_RESET}"
fi

if [ -n "$limits" ]; then
  line="${line} ${C_LABEL}|${C_RESET} ${C_LIMIT}${limits}${C_RESET}"
fi

if [ -n "$cost" ]; then
  line="${line} ${C_LABEL}|${C_RESET} ${C_COST}${cost}${C_RESET}"
fi

printf "%b" "$line"
