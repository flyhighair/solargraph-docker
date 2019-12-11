ARG RUBY_VERSION="2.6.4"
ARG ALPINE_VERSION="3.10"

FROM ruby:$RUBY_VERSION-alpine$ALPINE_VERSION

ENV APP_ROOT /usr/src/app

RUN apk update \
    && apk add --update make gcc g++

# Install gems
WORKDIR $APP_ROOT
COPY Gemfile Gemfile.lock ./
RUN gem install bundler
RUN bundle install --jobs=4
RUN gem install solargraph yard

# Install gem documentation
RUN yard gems

# Solargraph server port
EXPOSE 7658

# Run Solargraph
CMD [ "solargraph", "socket", "--host=0.0.0.0", "--port=7658" ]
