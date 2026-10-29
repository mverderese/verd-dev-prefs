#@IgnoreInspection BashAddShebang
#
# Light / dark terminal color switching.
#
# Built on the Tango palette -- the stock GNOME/freedesktop scheme. Its 16 ANSI
# colors are shared between the light and dark variants, so switching modes is
# just a handful of OSC escape sequences (swap foreground/background/cursor),
# one LS_COLORS value reads well in both, and the prompt uses the terminal's
# default foreground (set per mode below) so it stays legible either way.
# Light mode uses a pure white background with standard black text.
#
# Usage:
#   theme          # show the current mode
#   theme light    # switch the current terminal to light
#   theme dark     # switch the current terminal to dark
#   theme toggle   # flip between light and dark
#
# The choice is persisted to ~/.config/term-mode and re-applied for every new
# interactive shell, so new tabs/windows inherit the last mode you picked.

TERM_MODE_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/term-mode"
TERM_MODE_DEFAULT="light"

# ── Tango palette ──────────────────────────────────────────────────
# ANSI indices 0..15 -> hex (standard Tango mapping: 8 normal + 8 bright).
# Identical for both modes; this is what makes a single switch enough.
_tango_ansi=(
  2e3436 cc0000 4e9a06 c4a000   # black   red       green   yellow
  3465a4 75507b 06989a d3d7cf   # blue    magenta   cyan    white
  555753 ef2929 8ae234 fce94f   # br black br red    br green br yellow
  729fcf ad7fa8 34e2e2 eeeeec   # br blue  br magenta br cyan br white
)

# ls / tab-completion colors. Only normal (non-bold) ANSI colors are used so
# nothing maps to a washed-out "bright" variant; all read on both backgrounds.
#   31=red  32=green  33=yellow  34=blue  35=magenta  36=cyan
# File-type colors come first, then per-extension colors grouped by kind:
#   archives=red  images/video=magenta  audio/docs=yellow.
LS_COLORS="rs=0:di=36:ln=35:mh=0:pi=33:so=35:do=35:bd=34:cd=34:or=31:mi=31:su=31:sg=31:ca=0:tw=36:ow=36:st=37:ex=32"
() {
  local c
  for c in tar tgz tbz tz txz zip gz bz2 xz lz lzma 7z rar jar war ear deb rpm dmg iso z; do LS_COLORS+=":*.$c=31"; done
  for c in jpg jpeg png gif bmp tiff svg webp ico heic;                                    do LS_COLORS+=":*.$c=35"; done
  for c in mp4 mov mkv avi webm m4v wmv flv mpg mpeg;                                       do LS_COLORS+=":*.$c=35"; done
  for c in mp3 wav flac aac ogg m4a wma;                                                    do LS_COLORS+=":*.$c=33"; done
  for c in pdf doc docx xls xlsx ppt pptx odt;                                              do LS_COLORS+=":*.$c=33"; done
}
export LS_COLORS
# BSD fallback (file-type only) for any plain `ls -G`; mirrors the types above.
export LSCOLORS="gxfxfxdxcxegedabagacad"
export CLICOLOR=1

# Prefer GNU ls so the per-extension colors above actually render (BSD ls can't).
command -v gls >/dev/null && alias ls='gls --color=auto'

# Drive tab-completion from LS_COLORS too -- oh-my-zsh froze the old set before
# this file loaded, so re-point it at the palette above.
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ── Escape-sequence plumbing ───────────────────────────────────────
# Emit an OSC escape. Only fires for an interactive shell attached to a real
# terminal.
_osc() {
  [[ -o interactive && -t 1 ]] || return
  print -n -- "\e]$1\a"
}

# Push the shared 16-color ANSI ramp into the terminal.
_apply_palette() {
  local i
  for i in {0..15}; do
    _osc "4;$i;#${_tango_ansi[$((i + 1))]}"
  done
}

# Apply a mode to the current terminal (palette + fg/bg/cursor + prompt).
_term_apply() {
  local mode="$1"
  _apply_palette
  if [[ "$mode" == "light" ]]; then
    _osc "10;#000000"           # foreground (standard black)
    _osc "11;#ffffff"           # background (pure white)
    _osc "12;#000000"           # cursor
  else
    _osc "10;#d3d7cf"           # foreground (Tango light gray)
    _osc "11;#2e3436"           # background (Tango dark)
    _osc "12;#d3d7cf"           # cursor
  fi
  export TERM_MODE="$mode"
}

# ── Public command ─────────────────────────────────────────────────
theme() {
  case "${1:-status}" in
    light|dark)
      print -r -- "$1" > "$TERM_MODE_FILE"
      _term_apply "$1"
      print -- "Terminal switched to $1 mode."
      ;;
    toggle)
      [[ "${TERM_MODE:-$TERM_MODE_DEFAULT}" == "dark" ]] && theme light || theme dark
      ;;
    status)
      print -- "Current terminal mode: ${TERM_MODE:-unknown}"
      print -- "Usage: theme [light|dark|toggle]"
      ;;
    *)
      print -- "Unknown option: $1" >&2
      print -- "Usage: theme [light|dark|toggle]" >&2
      return 1
      ;;
  esac
}

# ── Apply the persisted (or default) mode on shell startup ─────────
() {
  local mode="$TERM_MODE_DEFAULT"
  [[ -r "$TERM_MODE_FILE" ]] && mode="$(<"$TERM_MODE_FILE")"
  _term_apply "$mode"
}
