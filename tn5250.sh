#!/bin/bash
#Luca Vercelli 2016
#released under GPL 2.0+
#dependencies: xterm, telnet, bash, sleep

VERSION="1.0"

GEOMETRY="80x24"
#FIXME 132x27 should work, but does not
COLOR="green"
TITLE="AS/400 5250 session"
FONT="Monospace"
FONTSIZE=12
#if you use DEFAULT_IP and call tn5250 from menu, you'll never change ip
DEFAULT_IP=

if [ -f /etc/tn5250.conf ] ;
then
  source /etc/tn5250.conf
fi

if [ -f ~/.tn5250.conf ] ;
then
  source ~/.tn5250.conf
fi

function usage(){
  echo "$0 [-v|--help|IP]"
  echo "Connect to a remote AS/400 server via 5250 protocol, at port 23."
  echo "This script is a simple wrapper to xterm and telnet."
}

if [ \( "$1" = "--help" \) -o \( "$1" = "-h" \) ] ;
then
  usage
  exit
fi

if [ \( "$1" = "--version" \) -o \( "$1" = "-v" \) ] ;
then
  echo "$0 v.$VERSION"
  exit
fi

if [ ! \( -z "$1"  \)  ] ;
then
  IP="$1"
else
  if [ ! \( -z "$DEFAULT_IP" \) ] ;
  then
    IP=$DEFAULT_IP
  else
    while [ -z "$IP" ] ;
    do
      echo "Connect to:"
      read IP
      if [ $? -eq 1 ] ;
      then
        #read failed because (we guess) tn5250 was launched from GUI
        xterm -geometry "$GEOMETRY" -fa "$FONT" -fs "$FONTSIZE" -fg "$COLOR" -T "IP Prompt" "$0"
        exit
      fi
    done
  fi
fi

#here IP is set

##### Run terminal #############################

#gnome-terminal --command="$0 --run $IP" --window-with-profile="$PROFILE" \
#  --hide-menubar --geometry="$GEOMETRY" --title="$TITLE"

#xterm accepts a single program as shell, with no arguments
SHELL=$(mktemp)
echo "#!/bin/bash

#remove myself
rm -rf \$0

#launch telnet
telnet $IP

#if connection fails, let the user see the error
if [ ! \( \$? -eq 0 \) ] ;
then
  read
fi

" > $SHELL

chmod o-w $SHELL
chmod a+x $SHELL

#FIXME should fix backspace, home, end

RESOURCES="*VT100.Translations: #override \
              <Key>BackSpace: string(\"\033[D\033[3~\")\n\
              <Key>End:       string(\"^]\")
"
xterm -xrm "$RESOURCES" -geometry "$GEOMETRY" -fa "$FONT" -fs "$FONTSIZE" -fg "$COLOR" -T "$TITLE" "$SHELL" &

#FIXME without sleep, when launched from menu, the previous command is not executed 
sleep 1

