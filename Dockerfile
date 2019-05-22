FROM ruby:2.6.3

ENV APP_ROOT "/bbs"
ENV RUBYOPT -EUTF-8

COPY . $APP_ROOT
WORKDIR $APP_ROOT
EXPOSE 5000

RUN gem install bundler
RUN bundle install
RUN bundler
