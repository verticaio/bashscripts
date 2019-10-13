#!/bin/bash
# example of trapping events and limiting thne shell stopping

# a SIGINT, which is the interrupt or control + C
# a SIGTERM kill command , duzgun qayda ile
# a SIGTSTP  cntrl+z and suspend command and script
# a SIGKILL force kill process

# For learning more about signal pls type "man 7 signal" command
clear

trap 'echo " - Please Press Q to Exit.." ' SIGINT SIGTERM  SIGTSTP   SIGKILL     # Yeni SIGINT ve ya SIGTERM signal bash vererse o zaman tek dirnaqdaki mesaji ver

while [ "$CHOICE" != "Q" ] && [ "$CHOICE" != "q" ];
do
    echo "MAIN MENU"
    echo "========="
    echo "1) Choice One"
    echo "2) Choice Two"
    echo "3) Choice Three"
    echo "Q) Quit/Exit"
    echo ""
    read CHOICE

    clear
done