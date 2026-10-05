# Terminal Animals v3 — a desktop companion that lives on your screen.
# The shell only sends small events; the dog is drawn by a native overlay app,
# so it works in any terminal that runs zsh (VS Code, IntelliJ, iTerm2, Terminal.app...).

[[ -n "${TERMINAL_ANIMALS_LOADED:-}" ]] && return
typeset -g TERMINAL_ANIMALS_LOADED=1
typeset -g TERMINAL_ANIMALS_ENABLED="${TERMINAL_ANIMALS_ENABLED:-1}"
typeset -g TERMINAL_ANIMALS_CHANCE="${TERMINAL_ANIMALS_CHANCE:-100}"
typeset -g _TA_HOME="${TERMINAL_ANIMALS_HOME:-$HOME/.terminal-animals}"
typeset -g _TA_BIN="$_TA_HOME/bin/terminal-animals-overlay"
typeset -g _TA_EVENTS="$_TA_HOME/run/events"
typeset -g _TA_PID="$_TA_HOME/run/pid"
typeset -g _TA_CONFIG="$_TA_HOME/config"
typeset -g _TA_LAST_CMD=""

_ta_running() {
  [[ -r "$_TA_PID" ]] || return 1
  kill -0 "$(<"$_TA_PID")" 2>/dev/null
}

_ta_start() {
  [[ "$OSTYPE" == darwin* && -x "$_TA_BIN" ]] || return 1
  _ta_running && return 0
  mkdir -p "$_TA_HOME/run"
  ( nohup "$_TA_BIN" >/dev/null 2>&1 & )
}

_ta_send() {
  [[ -d "$_TA_HOME/run" ]] || return
  print -r -- "$1" >> "$_TA_EVENTS"
}

_ta_preexec() { _TA_LAST_CMD="$1" }

_ta_precmd() {
  local rc=$?
  [[ "$TERMINAL_ANIMALS_ENABLED" == 1 && -n "$_TA_LAST_CMD" ]] || { _TA_LAST_CMD=""; return }
  _TA_LAST_CMD=""
  (( RANDOM % 100 < TERMINAL_ANIMALS_CHANCE )) || return
  _ta_running || _ta_start
  _ta_send "cmd $rc"
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec _ta_preexec
add-zsh-hook precmd _ta_precmd

# Wake the dog when a local interactive shell opens (skip over SSH).
[[ -z "${SSH_CONNECTION:-}" && "$TERMINAL_ANIMALS_ENABLED" == 1 ]] && _ta_start

# --- Appearance: coat / groom / accessory --------------------------------------
# The overlay owns the catalog (`--list`); choices are saved in $_TA_CONFIG, which
# doubles as the default for every new session, and a `reload` event applies them live.

_ta_config_set() {
  local key="$1" value="$2" line
  local -a kept=()
  if [[ -r "$_TA_CONFIG" ]]; then
    while IFS= read -r line; do [[ "$line" == "$key="* ]] || kept+=("$line"); done < "$_TA_CONFIG"
  fi
  mkdir -p "${_TA_CONFIG:h}"
  print -rl -- "${kept[@]}" "$key=$value" > "$_TA_CONFIG"
}

# Print the choices for one kind, marking the one currently in use.
_ta_show_choices() {
  local kind="$1" current key title
  current="$("$_TA_BIN" --show | sed -n "s/^$kind=//p")"
  "$_TA_BIN" --list "$kind" | while IFS=$'\t' read -r key title; do
    printf '  %s %-22s %s\n' "$([[ $key == "$current" ]] && echo '*' || echo ' ')" "$key" "$title"
  done
}

_ta_choose() {
  local kind="$1" name="${2:-}"
  [[ -x "$_TA_BIN" ]] || { echo "overlay not installed — run install.sh"; return 1; }
  if [[ -z "$name" ]]; then
    echo "${kind}s (* = current):"; _ta_show_choices "$kind"; return
  fi
  if ! "$_TA_BIN" --list "$kind" | cut -f1 | grep -qxF -- "$name"; then
    echo "unknown $kind '$name' — try: shihtzu $kind"; return 1
  fi
  _ta_config_set "$kind" "$name"
  _ta_start; _ta_send reload
  echo "🐾 $kind: $name"
}

_ta_kinds=(coat groom accessory)

# Pick a random coat, groom and accessory.
_ta_randomize() {
  [[ -x "$_TA_BIN" ]] || { echo "overlay not installed — run install.sh"; return 1; }
  local kind pick
  local -a keys
  for kind in $_ta_kinds; do
    keys=( ${(f)"$("$_TA_BIN" --list "$kind" | cut -f1)"} )
    pick="${keys[RANDOM % $#keys + 1]}"
    _ta_config_set "$kind" "$pick"
    echo "🎲 $kind: $pick"
  done
  _ta_start; _ta_send reload
}

# Back to the built-in defaults (no saved choices).
_ta_reset() {
  rm -f "$_TA_CONFIG"
  _ta_start; _ta_send reload
  echo "🐾 back to the default shih tzu"
}

shihtzu() {
  case "${1:-}" in
    on)    TERMINAL_ANIMALS_ENABLED=1; _ta_start; _ta_send show; echo "🐾 terminal animals: on" ;;
    off)   TERMINAL_ANIMALS_ENABLED=0; _ta_send hide; echo "terminal animals: off (dog is hiding)" ;;
    start) _ta_start && echo "🐶 dog started" || echo "overlay not installed — run install.sh" ;;
    quit)  _ta_send quit; echo "🐶 dog went home" ;;
    coat|groom|accessory) _ta_choose "$1" "${2:-}" ;;
    random) _ta_randomize ;;
    reset)  _ta_reset ;;
    list)
      [[ -x "$_TA_BIN" ]] || { echo "overlay not installed — run install.sh"; return 1; }
      local kind
      for kind in $_ta_kinds; do echo "${kind}s (* = current):"; _ta_show_choices "$kind"; done ;;
    *)     echo "usage: shihtzu {on|off|start|quit|list|random|reset|coat [name]|groom [name]|accessory [name]}" ;;
  esac
}

shihtzu-chance() {
  if [[ "$1" =~ '^[0-9]+$' ]] && (( $1 >= 0 && $1 <= 100 )); then
    TERMINAL_ANIMALS_CHANCE="$1"
    echo "🐾 reaction chance: ${1}%"
  else
    echo "usage: shihtzu-chance 50"
  fi
}
