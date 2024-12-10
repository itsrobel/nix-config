#!/bin/bash

# Prompt the user for their Bitwarden master password
if ! [ -n "$BW_SESSION" ]; then

  printf "Enter your Bitwarden master password: "
  stty -echo
  read BW_PASSWORD
  stty echo
  printf "\n"
  # read -s -p "Enter your Bitwarden master password: " BW_PASSWORD
  # echo

  # Unlock the vault and store the session key in a variable
  BW_SESSION=$(bw unlock --raw "$BW_PASSWORD")

  # Check if the unlock was successful
  if [ -n "$BW_SESSION" ]; then
    echo "Vault unlocked successfully"

    # Export the session key as an environment variable
    export BW_SESSION
    echo "BW_SESSION environment variable set. You can now use it in other scripts or commands."
  else
    echo "Failed to unlock the vault. Please check your password and try again."
  fi

  # Clear the password variable for security
  #echo $BW_SESSION
  export OPENAI_API_KEY=$(bw get password gpt --session "$BW_SESSION")
  unset BW_PASSWORD
else
  echo "BW_SESSION environment variable is already set"
fi
