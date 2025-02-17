# Change this according to your device
################
# Variables
################

# Keyboard input name
keyboard_input_name="1:1:AT_Translated_Set_2_keyboard"

# Date and time
date_and_week=$(date "+%d/%m/%Y")
current_time=$(date "+%H:%M")

#############
# Commands
#############

# Battery or charger
battery_charge=$(upower --show-info $(upower --enumerate | grep 'BAT') | egrep "percentage" | awk '{print $2}')
battery_status=$(upower --show-info $(upower --enumerate | grep 'BAT') | egrep "state" | awk '{print $2}')

# Sound status
#audio_sink=$(pactl list short sinks | cut -f1 | head -n 1)
#audio_volume=$(pactl list sinks | grep -A 15 "Sink #$audio_sink" | grep 'Volume:' | head -n 1 | awk '{print $5}')
#audio_is_muted=$(pactl list sinks | grep -A 15 "Sink #$audio_sink" | grep 'Mute:' | awk '{print $2}')

#if [ "$audio_is_muted" = "yes" ]; then
#    audio_active="🔇 Muted"
#else
#    audio_active="🔊 $audio_volume"
#fi

# Network
network=$(ip route get 1.1.1.1 | grep -Po '(?<=dev\s)\w+' | cut -f1 -d ' ')
# interface_easyname grabs the "old" interface name before systemd renamed it
interface_easyname=$(dmesg | grep $network | grep renamed | awk 'NF>1{print $NF}')
ping=$(ping -c 1 www.google.es | tail -1| awk '{print $4}' | cut -d '/' -f 2 | cut -d '.' -f 1)

# Others
language=$(swaymsg -r -t get_inputs | awk '/1:1:AT_Translated_Set_2_keyboard/;/xkb_active_layout_name/' | grep -A1 '\b1:1:AT_Translated_Set_2_keyboard\b' | grep "xkb_active_layout_name" | awk -F '"' '{print $4}')
#loadavg_5min=$(cat /proc/loadavg | awk -F ' ' '{print $2}')
mem_used=$(free | awk '/Mem:/ {printf("%.2f%%\n", $3/$2 * 100)}')
# Removed weather because we are requesting it too many times to have a proper
# refresh on the bar
#weather=$(curl -Ss 'https://wttr.in/Pontevedra?0&T&Q&format=1')

if [ $battery_status = "discharging" ];
then
    battery_pluggedin='🔋'
else
    battery_pluggedin='⚡'
fi

if ! [ $network ]
then
   network_active="⛔"
else
   network_active="🌍"
fi

# $audio_active
echo "Arch | ⌨ $language | $network_active $interface_easyname ($ping ms) | 🔗 $mem_used | $battery_pluggedin $battery_charge | $date_and_week ⌚ $current_time"
