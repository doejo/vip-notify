# Vip-Notify

Wordpress VIP deployments notifier.

It sends notifications to Slack when new VIP code gets deployed.

[![Build Status](https://magnum-ci.com/status/b38ad73f56d913f20cee41044ad9ae08.png)](https://magnum-ci.com/public/db8ac9168b65019f934d/builds)

## Install

Clone repository and install dependencies:

```
git clone git@gitlab.doejo.com:doejo/vip-notify.git
cd vip-notify
bundle install
```

## Configure

Application requires the following environment variables to function:

- `SLACK_TEAM`    - Team name on Slack
- `SLACK_TOKEN`   - Integration token
- `SLACK_CHANNEL` - Channel name to post updates to
- `SLACK_USER`    - Name of the user that sends notifications

## Start

To start application just run:

```
bundle exec thin start
```

## Endpoints

Test integration endpoint:

```
GET /test
```

Notifications endpoint:

```
POST /notify
```

Required params:

- `theme`             - Application theme name
- `deployer`          - Deployer name
- `deployed_revision` - Deployed commit ID
- `previous_revision` - Previously deployed commit ID

## License

The MIT License (MIT)

Copyright (c) 2014 Doejo LLC