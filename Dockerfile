FROM alpine:3.4
MAINTAINER info@megam.io

RUN apk update && apk --update add ruby ruby-irb ruby-json ruby-rake \
    ruby-bigdecimal ruby-io-console libstdc++ tzdata nodejs \
    libxml2-dev libffi-dev

ADD Gemfile /app/
ADD Gemfile.lock /app/

RUN apk --update add --virtual build-dependencies build-base ruby-dev openssl-dev \
    libc-dev linux-headers && \
    gem install bundler --no-rdoc  --no-ri && \
    cd /app; bundle install --without development test && \
    apk del build-dependencies

ADD . /app
RUN chown -R nobody:nogroup /app
USER nobody

ENV RAILS_ENV development
WORKDIR /app

# Precompile Rails assets
# RUN bundle exec rake assets:precompile RAILS_ENV=production

CMD ["bundle", "exec", "passenger", "-p", "3000", "--max-pool-size"]
