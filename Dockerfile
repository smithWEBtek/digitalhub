FROM ruby:2.5.3
MAINTAINER Eric Youngberg <eyoungberg@mapc.org>

WORKDIR /usr/src/app
VOLUME /usr/src/app
EXPOSE 3000

COPY Gemfile* ./
COPY vendor/extensions vendor/extensions

RUN set -ex \
    ; \
    apt-get update -qq \
    && apt-get install -y \
      git \
      tzdata \
      nodejs \
      build-essential \
      libxml2-dev \
      libxslt-dev \
      libc6 \
      postgresql \
      libpq-dev \
      apt-transport-https \
    ; \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq \
    && apt-get install -y yarn \
    ; \
    BUNDLE_FORCE_RUBY_PLATFORM=1 bundle install --jobs $(nproc)

CMD rm -f tmp/pids/server.pid && rails server -b 0.0.0.0
