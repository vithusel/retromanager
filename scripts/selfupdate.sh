#!/bin/bash
# Retro Manager © - 2023, https://vithuselservices.co.uk

root_check

source functions.sh

install_if_not dialog
install_if_not git

        consent=$(echo RetroManager is about to update itself)
        display_result "RetroManager Update"

pull_repo

        consent=$(echo Update Complete)
        display_result "RetroManager Update"

