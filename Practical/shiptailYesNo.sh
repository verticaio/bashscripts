#!/bin/bash

if ( whiptail --title "Test Yes/No Box" --yesno "Choose between Yes and No." 20 30 ) then 

echo "You chose Yes. Exit status was $?." 

else
    echo "You chose No. Exit status was $?."
fi
