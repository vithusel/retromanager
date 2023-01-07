# Retro Manager © - 2023, https://vithuselservices.co.uk

source <(curl -sL https://git.vithusel.me/vithusel/retromanager/-/raw/main/functions.sh)

install_if_not dialog

        consent=$(echo Prior to install this. Please ensure you have read the terms of use on the Repo readme. This software is in beta)
        display_consent 