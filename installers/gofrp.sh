#!/bin/bash

# Retro Manager © - 2023, https://vithuselservices.co.uk

    source functions.sh

    application=GoFRP
    consent=$(echo Do you have a AMD64 Machine?)
    display_consent 
    download_release $gofrprepo linux_amd64
    install_if_not tar
    tar -xvzf frp.tar.gz
    message=$(echo Will this be the $application server?)
    display_apphostserver 
    case $response in
      0 )
      echo installing GoFRP Server
      1 )
      echo installing GoFRP Client
    esac