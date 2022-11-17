### base stage ###

FROM ruby:3.1.2 AS base

ENV LANG=zh_CN.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
  curl \
  libpq-dev \
  libvips42 \
  nodejs \
  postgresql-client \
  yarnpkg && \
  ln -s /usr/bin/yarnpkg /usr/bin/yarn

RUN gem install bundler -v 2.3.6 && \
  bundle config set --local path vendor/bundle

WORKDIR /app

### CI stage ###

FROM base AS production

COPY Gemfile Gemfile.lock /app/

RUN bundle install

COPY package.json package-lock.json /app/

RUN npm install

COPY . /app/

RUN bin/rails assets:precompile
