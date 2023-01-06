#!/bin/bash

# Retro Manager © - 2023, https://vithuselservices.co.uk
source functions.sh
DIALOG_CANCEL=1
DIALOG_ESC=255
HEIGHT=0
WIDTH=0

#Root Check
root_check

while true; do
  exec 3>&1
  selection=$(dialog \
    --backtitle "Retro Manager © - 2023, https://vithuselservices.co.uk" \
    --title "Main Menu" \
    --clear \
    --cancel-label "Exit" \
    --menu "Please select:" $HEIGHT $WIDTH 4 \
    "1" "System Information" \
    "2" "Update System" \
    "3" "View Storage Usage" \
    "4" "System Service Management (LAMP)" \
    "5" "TBC" \
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-
  case $exit_status in
    $DIALOG_CANCEL)
      clear
      echo "Program terminated."
      exit
      ;;
    $DIALOG_ESC)
      clear
      echo "Program aborted." >&2
      exit 1
      ;;
  esac
  case $selection in
    1 )
      result=$(echo System Name: $HOSTNAME; IP Address: "hostname -i | awk '{print $3}'"  )
      display_result "System Information"
      ;;
    2 )
      result=$(df -h)
      display_result "Disk Space"
      ;;
    3 )
      if [[ $(id -u) -eq 0 ]]; then
        result=$(du -sh /home/* 2> /dev/null)
        display_result "Home Space Utilization (All Users)"
      else
        result=$(du -sh $HOME 2> /dev/null)
        display_result "Home Space Utilization ($USER)"
      fi
      ;;
  esac
done