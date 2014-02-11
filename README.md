# Vip-Notify

Wordpress VIP notifier.

It sends notifications to a slack channel when new stuff gets deployed.

## Requirements

- Ruby 2.0

## Install

Clone repository and install dependencies:

```
git clone git@gitlab.doejo.com:doejo/vip-notify.git
cd vip-notify
bundle install
```

## Configure

Application requires the following environment variables:

- `SLACK_TEAM` - Team name on Slack
- `SLACK_TOKEN` - Integration token
- `SLACK_CHANNEL` - Channel name to post updates to
- `SLACK_USER` - Name of the user that sends notifications

## Run

To start application just run:

```
thin start
```

## Endpoints

- `GET /test` - Test integration
- `POST /notify` - Process payload and send message to Slack