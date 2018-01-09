# Simple Slack Notifier
A small Docker container to send notifications to Slack via webhooks.
## Usage
1. Set up the [Incoming Webhook](https://api.slack.com/incoming-webhooks) integration on your Slack instance and get the Webhook URL
2. Build and run the docker image, passing the Webhook URL and a message to be sent

   ```
   docker build -t simple-slack-notifier .
   docker run --rm simple-slack-notifier -w [your_webhook_url] -m "Hello, world!"
   ```

### Message File
The contents of a file can be used for the slack message.

   ```
   echo "Uptime: `uptime`" > /tmp/uptime

   docker run \
     --rm \
     -v /tmp/uptime:/tmp/uptime-volume-mount \
     simple-slack-notifier \
     -w [your_webhook_url] \
     -f /tmp/uptime-volume-mount
   ```

### Environment Variables
Webhook URL, Message, and Message File can also be passed as environment variables.
 - SLACK_WEBHOOK_URL
 - SLACK_MESSAGE
 - SLACK_MESSAGE_FILE

   ```
    docker run \
      --rm \
      -e SLACK_WEBHOOK_URL=[your_webhook_url] \
      -e SLACK_MESSAGE=":pig: Bacon ipsum dolor amet... :pig:" \
      simple-slack-notifier
   ```
This works particularly well for a Kubernetes environment or in a Google Cloud Container Builder cloudbuild.yaml file for sending notifications based on events or builds.
