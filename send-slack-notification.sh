#!/bin/sh

usage()
{
cat << EOF
Usage: $0 <options>

OPTIONS:
   -w <url>         Slack Webhook URL (required)
   -m <message>     Message to send to slack (cannot be used with -f)
   -f <filename>    File containing message to send to slack (cannot be used with -m)
Webhook URL and either message OR filename required.
EOF
}

while getopts "w:m:f:" opt
do
  case $opt in
    w)
      SLACK_WEBHOOK_URL="$OPTARG"
      ;;
    m)
      SLACK_MESSAGE="$OPTARG"
      ;;
    f)
      SLACK_MESSAGE_FILE="$OPTARG"
      ;;
    ?)
      usage
      exit 1
      ;;
  esac
done

if [ "$SLACK_WEBHOOK_URL" = "" ]; then
  echo "Error: Webhook URL not provided.\n\n"
  usage
  exit 1;
fi

if [ "$SLACK_MESSAGE" = "" ] && [ "$SLACK_MESSAGE_FILE" = "" ]; then
  echo "Error: message or filename required\n\n"
  usage
  exit 1;
fi

if [ "$SLACK_MESSAGE" != "" ] && [ "$SLACK_MESSAGE_FILE" != "" ]; then
  echo "Error: only one source option (message or filename) may be provided\n\n"
  usage
  exit 1;
fi

if [ "$SLACK_MESSAGE_FILE" != "" ]; then
  if [ -f $SLACK_MESSAGE_FILE ]; then
    SLACK_MESSAGE=`cat "$SLACK_MESSAGE_FILE"`
  else
    echo "File: $SLACK_MESSAGE_FILE not found"
    exit 1;
  fi
fi

echo "Sending message to Slack: $SLACK_MESSAGE"
curl -s -X POST --data-urlencode "payload={\"text\":\"$SLACK_MESSAGE\"}" "$SLACK_WEBHOOK_URL"
