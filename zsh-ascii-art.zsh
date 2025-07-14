#!/usr/bin/env zsh

# Export essential variables for subprocesses
export ASCII_ART_DIR="${ASCII_ART_DIR:-${HOME}/.config/ascii}"
export ASCII_ART_EXTENSION="${ASCII_ART_EXTENSION:-.txt}"

# Ensure directory exists
[[ ! -d "$ASCII_ART_DIR" ]] && mkdir -p "$ASCII_ART_DIR"

# Private functions (prefix with _)
_ascii_log() { [[ "$ZSH_ASCII_DEBUG" == "true" ]] && echo "[ascii-art] $*" >&2 }
_ascii_error() { echo "[ascii-art] ERROR: $*" >&2 }

_ascii_find() {
  local file="${ASCII_ART_DIR}/${1}${ASCII_ART_EXTENSION}"
  [[ -f "$file" && -r "$file" ]] && echo "$file"
}

_ascii_search() {
  local -a search_order=(
    ${ZSH_ASCII_ART:+$ZSH_ASCII_ART}
    "$HOST" "$USER" "$(uname -s)" "default"
  )
  
  _ascii_log "Searching: ${search_order[*]}"
  
  local name file
  for name in $search_order; do
    if file=$(_ascii_find "$name"); then
      _ascii_log "Found: $file"
      echo "$file"
      return 0
    fi
  done
  return 1
}

_ascii_validate() {
  [[ -n "$1" && "$1" =~ ^[a-zA-Z0-9._-]+$ ]] || {
    _ascii_error "Invalid name. Use only letters, numbers, dots, hyphens, underscores"
    return 1
  }
}

# Public API
ascii_art_path() { _ascii_find "${1:-$(_ascii_search || echo default)}" }

ascii_art_print() {
  local file
  file=$(ascii_art_path "$1") || {
    _ascii_error "ASCII art not found: ${1:-auto}"
    return 1
  }
  cat "$file"
}

ascii_art_list() {
  local -a files=()
  
  # Collect files efficiently
  files=( ${ASCII_ART_DIR}/*${ASCII_ART_EXTENSION}(N:t:r) )
  
  if (( ${#files[@]} == 0 )); then
    _ascii_error "No ASCII files in $ASCII_ART_DIR"
    return 1
  fi
  
  echo "ASCII art files (${#files[@]}):"
  printf "  %s\n" $files
  
  # Show current selection
  local current
  if current=$(_ascii_search); then
    echo "\nCurrent: ${current:t:r}"
  fi
}

ascii_art_edit() {
  _ascii_validate "$1" || return 1
  ${EDITOR:-nano} "${ASCII_ART_DIR}/${1}${ASCII_ART_EXTENSION}"
}

ascii_art_create() {
  _ascii_validate "$1" || return 1
  
  local file="${ASCII_ART_DIR}/${1}${ASCII_ART_EXTENSION}"
  
  if [[ -f "$file" ]]; then
    echo -n "File exists. Overwrite? (y/N): "
    read -q || { echo; return 1; }
    echo
  fi
  
  cat > "$file" << 'EOF'
# ASCII Art Template - Remove this line
     ___
    /   \
   | o o |
    \___/
EOF
  
  echo "Created: $1"
  echo "Edit with: ascii_art_edit $1"
}

# Main neofetch integration
asciifetch() {
  if ! command -v neofetch >/dev/null; then
    _ascii_error "neofetch not installed"
    return 1
  fi
  
  local ascii_file
  if ascii_file=$(_ascii_search); then
    _ascii_log "Using: ${ascii_file:t:r}"
    command neofetch --ascii "$ascii_file" "$@"
  else
    _ascii_log "No ASCII found, using default neofetch"
    command neofetch "$@"
  fi
}

# Override neofetch command
neofetch() { asciifetch "$@" }

# Completions
_ascii_art_files() {
  local -a files=( ${ASCII_ART_DIR}/*${ASCII_ART_EXTENSION}(N:t:r) )
  _describe 'ascii files' files
}

compdef _ascii_art_files ascii_art_print ascii_art_edit

# Auto-startup
(( ${+ZSH_ASCII_OPEN} )) && [[ "$ZSH_ASCII_OPEN" == "true" ]] && {
  command -v neofetch >/dev/null && asciifetch
}

