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

rm functions.sh

wget https://git.vithusel.me/vithusel/retromanager/-/raw/main/functions.sh

root_check

source functions.sh

install_if_not dialog
install_if_not git

        consent=$(echo Prior to install this. Please ensure you have read the terms of use on the readme. This software is in beta)
        display_consent 

clone_repo $mainrepo

echo ls
ls

sudo chown -R "${USER:=$(/usr/bin/id -run)}:$USER" retromanager

cd retromanager

echo ls
ls

chmod +x complete-install.sh

./complete-install.sh
