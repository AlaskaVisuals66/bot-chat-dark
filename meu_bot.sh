#!/bin/sh

while true; do
    update=$(curl -s "https://api.telegram.org/bot6171128157:AAEAuEbjtwzqgeaSPtyYU7T5Mi5xdCKAcg4/getUpdates?offset=-1")
    message=$(echo "$update" | jq -r '.result[].message.text')
    chat_id=$(echo "$update" | jq -r '.result[].message.chat.id')

    if [ "$message" != "" ]; then
        output=$(curl -s https://api.openai.com/v1/completions \
          -H 'Content-Type: application/json' \
          -H 'Authorization: Bearer $CHATGPT_TOKEN' \
          -d '{
          "model": "text-davinci-003",
          "prompt": "'"$message"'",
          "max_tokens": 4000,
          "temperature": 1.0
        }' \
        --insecure | jq -r '.choices[].text')
        curl -s -X POST "https://api.telegram.org/bot6171128157:AAEAuEbjtwzqgeaSPtyYU7T5Mi5xdCKAcg4/sendMessage" -d "chat_id=5945507382&text=$output"
    fi
    sleep 1
done
