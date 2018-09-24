FROM ruby:2.5

WORKDIR /app

ENV RAILS_ENV production
COPY Gemfile Gemfile.lock ./
RUN bundle --deployment --without "development test"

COPY . ./

ENTRYPOINT /app/bin/entrypoint
