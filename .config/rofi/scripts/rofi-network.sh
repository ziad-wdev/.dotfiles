#!/usr/bin/env bash

notify-send "Getting list of available Wi-Fi networks..."

# Get current state to set the correct toggle action
wifi_state=$(nmcli -fields WIFI g)
if [[ "$wifi_state" =~ "enabled" ]]; then
	toggle="󰤭  Disable Wi-Fi"
elif [[ "$wifi_state" =~ "disabled" ]]; then
	toggle="󰤨  Enable Wi-Fi"
fi

# Get a list of available wifi connections and morph it into a nice-looking list
wifi_list=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.?\S/ /g" | sed "s/^--/ /g" | sed "s/  //g" | sed "/--/d")

# Select network using rofi
chosen_network=$(echo -e "$toggle\n$wifi_list" | uniq -u | rofi -dmenu -config ~/.config/rofi/configs/network.rasi -p "󰤨  NETWORK")

# Get name of connection
read -r chosen_id <<< "${chosen_network:3}"

# Calculate the output
if [ "$chosen_network" = "" ]; then
  # Exit if no network selected
	exit
elif [ "$chosen_network" = "󰤨  Enable Wi-Fi" ]; then
  # Enable Wi-Fi
	nmcli radio wifi on
elif [ "$chosen_network" = "󰤭  Disable Wi-Fi" ]; then
  # Disable Wi-Fi
	nmcli radio wifi off
else
  # Connect to the selected Wi-Fi network

  # Format success message
  success_message="You are now connected to the Wi-Fi network \"$chosen_id\"."

	# Get saved connections
	saved_connections=$(nmcli -g NAME connection)

	# Check if connection is already saved
	if [[ $(echo "$saved_connections" | grep -w "$chosen_id") = "$chosen_id" ]]; then
	  # Connection is already saved, connect and notify on success
		nmcli connection up id "$chosen_id" | grep "successfully" && notify-send "Connection Established" "$success_message"
	else
		# Format password prompt if connection is not saved
		if [[ "$chosen_network" =~ "" ]]; then
			wifi_password=$(rofi -dmenu -password -config ~/.config/rofi/configs/password.rasi -p "󰟵  PASSWORD")
		fi

		# Connect to the selected Wi-Fi network and notify on success
		nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep "successfully" && notify-send "Connection Established" "$success_message"
	fi
fi
