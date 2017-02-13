#!/bin/sh

# -----------------------------------------------------------------------------------------------------------------------------
# see: http://stackoverflow.com/questions/12782318/add-udev-rule-for-external-display
#      https://ruedigergad.com/2012/01/28/hotplug-an-external-screen-to-your-laptop-on-linux/
#      http://unix.stackexchange.com/questions/14854/xrandr-command-not-executed-within-shell-command-called-from-udev-rule
# -----------------------------------------------------------------------------------------------------------------------------
 
export DISPLAY=:0
export XAUTHORITY=/home/$USERNAME/.Xauthority


MAIN="VGA1"
SECONDARY="DP2-2"
BUILTIN="eDP1"

has_main=`xrandr|grep "${MAIN} connected"`
has_secondary=`xrandr|grep "${SECONDARY} connected"`
has_builtin=`xrandr|grep "${BUILTIN} connected"`

# Both monitors are connected
# ---------------------------
if [ ! -z "$has_main" ] && [ ! -z "$has_secondary" ];then
   xrandr --output ${SECONDARY} --mode 1680x1050 --output ${MAIN} --mode 1920x1200 --primary --right-of ${SECONDARY} --output ${BUILTIN} --off
   echo "Set up dual monitors"
fi


# Only the 'small' one is connected
# ---------------------------------
if [ ! "$has_main" ] && [ ! -z "$has_secondary" ];then
   xrandr --output ${SECONDARY} --mode 1680x1050 --primary --output ${MAIN} --off --output ${BUILTIN} --off
   echo "Set up ${SECONDARY}"
fi

# Only the 'big' monitor is connected
# -----------------------------------
if [ ! -z "$has_main" ] && [ ! "$has_secondary" ];then
   xrandr --output ${SECONDARY} --off --output ${MAIN} --mode 1920x1200 --primary --output ${BUILTIN} --off
   echo "Set up ${MAIN}"
fi

# The laptop monitor is used
# --------------------------
if [ ! "$has_main" ] && [ ! "$has_secondary" ];then
   xrandr --output ${SECONDARY} --off --output ${MAIN} --off --output ${BUILTIN} --mode 1920x1080 --primary
   echo "Set up built in monitor"
fi

