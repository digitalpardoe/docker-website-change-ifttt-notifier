FROM alpine:3.12

RUN apk add --no-cache ruby chromium-chromedriver ruby-json chromium
RUN gem install selenium-webdriver diffy

ENV WEBSITE_TO_CHECK=""
ENV IFTTT_WEBHOOK_KEY=""
ENV IFTTT_WEBHOOK_EVENT=""

VOLUME ["/output"]

COPY ["website-change-ifttt-notifier.rb", "/usr/local/bin/website-change-ifttt-notifier"]

RUN echo '* * * * * /usr/local/bin/website-change-ifttt-notifier' > /etc/crontabs/root

CMD ["/usr/sbin/crond", "-f"]
