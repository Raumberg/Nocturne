
# Aliases
alias cls="clear"
alias vim="nvim"
alias ls="lsd"
alias noc.upgrade="sudo apt-get update && sudo apt-get upgrade"
alias noc.tar="tar -cvzf"
alias noc.untar="tar -xvf"
alias noc.encr="gpg -o encr.gpg -c"
alias noc.decr="gpg -o decr.pgp -d"


# Display critical errors
alias syslog_emerg="sudo dmesg --level=emerg,alert,crit"

# Output common errors
alias syslog="sudo dmesg --level=err,warn"

# Print logs from x server
alias xlog='grep "(EE)\|(WW)\|error\|failed" ~/.local/share/xorg/Xorg.0.log'

# Remove archived journal files until the disk space they use falls below 100M
alias vacuum="journalctl --vacuum-size=100M"

# Make all journal files contain no data older than 2 weeks
alias vacuum_time="journalctl --vacuum-time=2weeks"

set -U fish_greeting
set fish_color_command cyan
set -gx EDITOR nvim
set -gx VISUAL micro
set -gx BROWSER /usr/bin/firefox


if status is-interactive
    # Commands to run in interactive sessions can go here
end
