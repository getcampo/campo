## base stage

FROM ubuntu:18.04 AS base

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  imagemagick \
  libpq-dev \
  nodejs \
  postgresql-client \
  ruby \
  ruby-dev \
  zlib1g-dev

RUN apt-get update && apt-get install -y --no-install-recommends curl gnupg && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y --no-install-recommends yarn && \
  apt-get autoremove -y curl gnupg

RUN gem install bundler -v 2.0.2

WORKDIR /campo

## testing stage

FROM base AS testing

COPY Gemfile Gemfile.lock /campo/
RUN bundle install --deployment

COPY package.json yarn.lock /campo/
RUN yarn install

COPY . /campo/

## production stage

FROM base AS production

ENV RAILS_ENV=production

COPY . /campo/

RUN bundle install --deployment --without test development && \
  rm vendor/bundle/ruby/2.5.0/cache/*

RUN yarn install && \
  bin/rails assets:precompile && \
  yarn cache clean && \
  rm -rf node_modules tmp/cache/* /tmp/*
