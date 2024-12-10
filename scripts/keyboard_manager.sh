#!/bin/bash

set -x # This enables bash debugging output

get_builtin_keyboard_id() {
  xinput list | grep -i "Your Keyboard Name" | grep -o 'id=[0-9]*' | cut -d= -f2
}

is_external_keyboard_connected() {
  xinput list | grep -i "keyboard" | grep -v "Your Keyboard Name" | grep -q .
}

disable_builtin_keyboard() {
  local id=$(get_builtin_keyboard_id)
  echo "Attempting to disable keyboard with ID: $id"
  if [ -z "$id" ]; then
    echo "Error: Could not find built-in keyboard ID"
    return
  fi
  if xinput list-props $id | grep -q "Device Enabled.*:.*1"; then
    xinput float $id
    if [ $? -eq 0 ]; then
      echo "Built-in keyboard disabled successfully"
    else
      echo "Failed to disable built-in keyboard"
    fi
  else
    echo "Built-in keyboard already disabled or not found"
  fi
}

enable_builtin_keyboard() {
  local id=$(get_builtin_keyboard_id)
  echo "Attempting to enable keyboard with ID: $id"
  if [ -z "$id" ]; then
    echo "Error: Could not find built-in keyboard ID"
    return
  fi
  if xinput list-props $id | grep -q "Device Enabled.*:.*0"; then
    xinput reattach $id 3
    if [ $? -eq 0 ]; then
      echo "Built-in keyboard enabled successfully"
    else
      echo "Failed to enable built-in keyboard"
    fi
  else
    echo "Built-in keyboard already enabled or not found"
  fi
}

# Main loop
while true; do
  echo "Checking for external keyboard..."
  if is_external_keyboard_connected; then
    echo "External keyboard detected"
    disable_builtin_keyboard
  else
    echo "No external keyboard detected"
    enable_builtin_keyboard
  fi
  sleep 5
done
