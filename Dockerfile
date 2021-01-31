FROM alpine:3.12

RUN apk add --no-cache ruby ruby-json build-base ruby-dev libxml2-dev libxslt-dev
RUN gem install diffy
RUN gem install nokogiri -- --use-system-libraries

ENV WEBSITE_TO_CHECK=""
ENV IFTTT_WEBHOOK_KEY=""
ENV IFTTT_WEBHOOK_EVENT=""

VOLUME ["/output"]

COPY ["website-change-ifttt-notifier.rb", "/usr/local/bin/website-change-ifttt-notifier"]

RUN echo '* * * * * /usr/local/bin/website-change-ifttt-notifier' > /etc/crontabs/root

CMD ["/usr/sbin/crond", "-f"]

LABEL org.opencontainers.image.source https://github.com/digitalpardoe/docker-website-change-ifttt-notifier