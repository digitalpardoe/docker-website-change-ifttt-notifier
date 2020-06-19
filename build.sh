#!/bin/bash

readonly OUTPUT="website-change-ifttt-notifier.tar"

rm $OUTPUT
docker build -t digitalpardoe/website-change-ifttt-notifier:latest .
docker save digitalpardoe/website-change-ifttt-notifier:latest > $OUTPUT
