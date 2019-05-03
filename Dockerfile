FROM ruby:2.6.3

ENV APP_ROOT /usr/src/bbs

COPY . $APP_ROOT
WORKDIR $APP_ROOT
EXPOSE 5000

RUN gem install bundler
RUN bundler
