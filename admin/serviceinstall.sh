#!/bin/bash

# Retro Manager © - 2023, https://vithuselservices.co.uk
source functions.sh

apt update

while true; do
  exec 3>&1
  selection=$(dialog \
    --backtitle "Retro Manager © - 2023, https://vithuselservices.co.uk" \
    --title "Install Services / Applications" \
    --clear \
    --cancel-label "Back" \
    --menu "Please select:" $HEIGHT $WIDTH 4 \
    "1" "LAMP (Non Functional)" \
    "2" "GoFRP" \
    "3" "Custom (Non Functional)" \
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-
  case $exit_status in
    $DIALOG_CANCEL)
      clear
      echo "Going to main menu"
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
      apt update
      ;;
    2 )
      consent=$(echo Do you have a AMD64 Machine?)
      display_consent 
      download_release $gofrprepo linux_amd64 frp.tar.gz
      ;;
    3 )
      apt upgrade -y
      ;;
  esac
done