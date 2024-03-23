#!/bin/bash

# File to store the last IP address
IP_FILE="last_ip_address.txt"

# Fetch the current public IP address
CURRENT_IP=$(curl -s http://ipecho.net/plain)

# Check if the file exists and read the last IP
if [ -f "$IP_FILE" ]; then
	PREVIOUS_IP=$(cat $IP_FILE)
else
	PREVIOUS_IP=""
fi

# Compare the current IP with the last known IP
if [ "$CURRENT_IP" != "$PREVIOUS_IP" ]; then
	echo "IP has changed to $CURRENT_IP"
	echo $CURRENT_IP >> log.txt
	# Update the IP file with the current IP
	echo "$CURRENT_IP" > "$IP_FILE"

	# Email settings
	SENDER="pintertamas99+ip-address-change@gmail.com"
	RECIPIENT="pintertamas99+ip-address-change@gmail.com"
	SUBJECT="Home router IP Address has been changed"
	AWS_REGION="eu-central-1"
	CHARSET="UTF-8"
	TEMP_HTML=temp_email.html
	TEMP_JSON=temp_message.json

	sed "s/{{IP_ADDRESS}}/$CURRENT_IP/" new_ip_email_template.html  > $TEMP_HTML

	# Prepare the JSON payload
	cat <<EOF >$TEMP_JSON
	{
  		"Subject": {
    			"Data": "$SUBJECT",
    			"Charset": "$CHARSET"
  		},
  		"Body": {
    			"Html": {
      				"Data": "$(cat $TEMP_HTML | sed 's/"/\\"/g' | tr -d '\n')",
      				"Charset": "$CHARSET"
    			}
  		}
	}
EOF

	# Send email
        aws ses send-email \
                --from "$SENDER" \
                --destination "ToAddresses=$RECIPIENT" \
                --message file://$TEMP_JSON \
                --region $AWS_REGION
fi

# Cleanup temporary files
rm -f $TEMP_HTML
rm -f $TEMP_JSON
