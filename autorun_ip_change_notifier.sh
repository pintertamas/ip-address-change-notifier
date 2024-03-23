#!/bin/bash

# Path to your main script
SCRIPT="/ip_change_notification.sh"

# Loop indefinitely
while true; do
  "$SCRIPT"
  # Wait for 600 seconds (10 minutes) before running it again
  sleep 600
done

#################################################################################
#										#
#	run 'crontab -e'							#
#	then add this to the list: '@reboot /bin/bash /autorun_ip_change.sh'	#
#										#
#################################################################################
