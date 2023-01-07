#!/bin/bash
# Retro Manager © - 2023, https://vithuselservices.co.uk

# Install curl if not existing
if [ "$(dpkg-query -W -f='${Status}' "curl" 2>/dev/null | grep -c "ok installed")" = "1" ]
then
    echo "curl OK"
else
    apt-get update -q4
    apt-get install curl -y
fi

wget https://git.vithusel.me/vithusel/retromanager/-/raw/main/functions.sh

source functions.sh

install_if_not dialog

        consent=$(echo Prior to install this. Please ensure you have read the terms of use on the readme. This software is in beta)
        display_consent 