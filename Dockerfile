FROM ubuntu:18.04

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

WORKDIR /app

RUN gem install bundler
COPY Gemfile Gemfile.lock /app/
RUN bundle install

COPY . /app/
RUN bundle exec bin/rails assets:precompile

CMD bundle exec rails s -b 0.0.0.0
