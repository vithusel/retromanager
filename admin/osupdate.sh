#!/bin/bash

# Retro Manager © - 2023, https://vithuselservices.co.uk
source functions.sh

apt update

while true; do
  exec 3>&1
  selection=$(dialog \
    --backtitle "Retro Manager © - 2023, https://vithuselservices.co.uk" \
    --title "Update OS" \
    --clear \
    --cancel-label "Exit" \
    --menu "Please select:" $HEIGHT $WIDTH 4 \
    "C" "System Information" \
    "U" "Update System" \
    "N" "View Storage Usage" \
    "T" "System Service Management (LAMP)" \
    "S" "TBC" \
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
    C )
      result=$(echo "System Name: $HOSTNAME"; echo "Local IP: $localip"; uptime)
      display_result "System Information"
      ;;
    U )
      result=$(df -h)
      display_result "Disk Space"
      ;;
    N )
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