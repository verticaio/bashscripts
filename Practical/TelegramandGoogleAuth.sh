
### Step1 configure bot and telegram channel
BotFather
/start
/newbot 
SSHlogins
cyberssh_bot
Use this token to access the HTTP API:
token_example
Talk this bot and get chat id 
curl  "https://api.telegram.org/bottoken_example/getUpdates"



### Step 2 : Create script and insert key and chat_id

#!/bin/bash
KEY="token_example"
URL="https://api.telegram.org/bot$KEY/sendMessage"
TARGET="230783293" # Telegram ID of the conversation with the bot, get it from /getUpdates API
TEXT="User *$PAM_USER* logged in on *$HOSTNAME* at $(date '+%Y-%m-%d %H:%M:%S %Z')
Remote host: $PAM_RHOST
Remote user: $PAM_USER
Service: $PAM_SERVICE
TTY: $PAM_TTY"

PAYLOAD="chat_id=$TARGET&text=$TEXT&parse_mode=Markdown&disable_web_page_preview=true"

# Run in background so the script could return immediately without blocking PAM
curl -s --max-time 10 --retry 5 --retry-delay 2 --retry-max-time 10 -d "$PAYLOAD" $URL > /dev/null 2>&1 &

 ### Step 3 
 # Add to /etc/pam.d/sshd
 session     required      pam_exec.so   type=open_session seteuid /usr/local/bin/tgbot.sh


### LINK: https://linuxer.pro/2017/05/get-real-time-telegram-notification-when-ssh-login-on-linux/