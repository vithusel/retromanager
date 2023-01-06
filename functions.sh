# Retro Manager © - 2023, https://vithuselservices.co.uk

# Centralised functions for repo

display_result() {
  dialog --title "$1" \
    --no-collapse \
    --msgbox "$result" 0 0
}
