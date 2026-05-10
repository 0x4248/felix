alias c="clear"
alias cls="clear"

alias copy="cp"
alias move="mv"
alias dir="directory"
alias d="directory"
alias fdir="directory -f"

alias fcd="cd /mnt/floppy"




PS1="\w $ "

PATH=$PATH:/root/felix/scripts
PRINTER=/dev/usb/lp1
PRN=PRINTER

BUZZER=/dev/ttyACM0
BUZZ=BUZZER
SPEAKER=BUZZER
SPKR=SPEAKER

alias mute="echo 0 > $BUZZER"
alias alarm="while true; do echo 2000 > $BUZZER; sleep 1; echo 0 > $BUZZER; sleep 1; done"
alias cut="echo -e '\n\n\n\n\n\x1D\x56\x00' > $PRINTER"

# Print takes in pipe and prints it without cutting
aliss pr= "cat - | tee > $PRINTER"
alias prc="cat - | tee > $PRINTER && cut"
alias prf= "echo -e '\n\n\n\n\n\x1D\x56\x00' > $PRINTER; echo -e '*** $(date) ***\n' | tee > $PRINTER; cat - | tee > $PRINTER && cut"