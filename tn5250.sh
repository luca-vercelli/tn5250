#!/bin/bash
#Luca Vercelli 2016
#released under GPL 2.0+
#dependencies: xterm, telnet, bash

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
  fi
fi

##### Run terminal #############################

#gnome-terminal --command="$0 --run $IP" --window-with-profile="$PROFILE" \
#  --hide-menubar --geometry="$GEOMETRY" --title="$TITLE"

#xterm accepts a single program as shell, with no arguments
#telnet -E means no way to exit
SHELL=$(mktemp)
echo "#!/bin/bash
IP=$IP
while [ -z \"\$IP\" ] ;
do
  echo \"Connect to:\"
  read IP
done;

telnet -E \$IP

if [ ! \( \$? -eq 0 \) ] ;
then
  read
fi
" > $SHELL

chmod o-w $SHELL
chmod a+x $SHELL
#FIXME should fix backspace, home, end
xterm -geometry "$GEOMETRY" -fa "$FONT" -fs "$FONTSIZE" -fg "$COLOR" -T "$TITLE" $SHELL
rm -rf $SHELL 

