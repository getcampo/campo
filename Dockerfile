## base stage

FROM ubuntu:18.04 AS base

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  curl \
  gnupg \
  imagemagick \
  libpq-dev \
  nodejs \
  postgresql-client \
  ruby \
  ruby-dev \
  zlib1g-dev

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y --no-install-recommends yarn

RUN gem install bundler

WORKDIR /app

## release stage

FROM base

COPY Gemfile Gemfile.lock /app/
RUN bundle install --deployment

COPY package.json yarn.lock /app/
RUN yarn install

COPY . /app/
RUN bin/rails assets:precompile
