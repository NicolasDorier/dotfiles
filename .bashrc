# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'
export SYSTEMD_LESS=FRX
export PATH="$HOME/.local/bin:$PATH:$HOME/.dotnet/tools"
alias vim="nvim"
alias cat="bat"
alias gitcp="git commit -a --amend --no-edit; git push -f"
eval "$(zoxide init bash)"

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

# Default device
export SANE_DEFAULT_DEVICE="epjitsu:libusb:003:007"