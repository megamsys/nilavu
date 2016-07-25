FROM gliderlabs/alpine:latest
MAINTAINER info@megam.io

RUN apk update && apk --update add ruby \
    ruby-io-console ca-certificates libssl1.0 openssl libstdc++ \
    libxml2-dev libffi-dev

ADD Gemfile /app/
ADD Gemfile.lock /app/

RUN apk --update add --virtual build-dependencies ruby-dev build-base openssl-dev && \
    gem install bundler --no-ri --no-rdoc && \
    cd /app ; bundle install --without development test && \
    apk del build-dependencies

ADD . /app
RUN chown -R nobody:nogroup /app
USER nobody

ENV RAILS_ENV development
EXPOSE 3000

WORKDIR /app


# Precompile Rails assets
# RUN bundle exec rake assets:precompile RAILS_ENV=production

CMD ["bundle", "exec", "passenger", "-p", "3000", "--max-pool-size"]
