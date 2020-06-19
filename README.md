This image pulls a copy of a webpage every minute and diffs it against a previous version, if it detects a change above a certain threshold it can send a webhook to the IFTTT webhooks API.

## Usage

```
docker run \
  -e WEBSITE_TO_CHECK=<your-pocket-consumer-key> \
  -e IFTTT_WEBHOOK_KEY=<your-pocket-access-token> \
  -e IFTTT_WEBHOOK_EVENT=<your-pocket-access-token> \
  -v </path/to/output/folder>:/output \
  digitalpardoe/website-change-ifttt-notifier
```

## Parameters

* `-v /output` - files are rotated in this directory as changes are detected

## Environmental Variables

### Required

* `WEBSITE_TO_CHECK` - URL to the website / page you wish to check
* `IFTTT_WEBHOOK_KEY` - your IFTTT webhook key
* `IFTTT_WEBHOOK_EVENT` - your IFTTT webhook event name

### Optional

* `CHANGE_THRESHOLD` - percentage change to notify above
