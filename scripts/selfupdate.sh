#!/bin/bash
# Retro Manager © - 2023, https://vithuselservices.co.uk

root_check

source functions.sh

install_if_not dialog
install_if_not git

        result=$(echo RetroManager is about to update itself)
        display_result "RetroManager Update"

pull_repo

        result=$(echo Update Complete)
        display_result "RetroManager Update"

