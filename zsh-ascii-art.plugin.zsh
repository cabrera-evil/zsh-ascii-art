#!/usr/bin/env zsh
# ~/.oh-my-zsh/custom/plugins/ascii-art/ascii-art.plugin.zsh
#
# ASCII Art Plugin for Oh My Zsh
# Integrates custom ASCII art with neofetch
#
# Author: cabrera-evil

# Plugin configuration with sane defaults
: ${ZSH_ASCII_ART:=""}
: ${ZSH_ASCII_OPEN:="false"}
: ${ZSH_ASCII_DEBUG:="false"}

# Source the main script
source "${0:A:h}/zsh-ascii-art.zsh"

# Aliases for convenience
alias aa='ascii_art_print'
alias aal='ascii_art_list'
alias aae='ascii_art_edit'
alias aac='ascii_art_create'
