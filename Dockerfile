FROM docker.io/library/ruby:3.2.2 AS base
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle config set --global frozen 1

FROM base AS development
RUN bundle config set without "acceptance_test" \
      && bundle install
COPY hello.rb ./
COPY ./features features/
ENTRYPOINT ["bundle", "exec"]
CMD ["rspec"]

FROM base AS capybara
RUN bundle config set without "unit_test" \
      && apt-get update \
      && apt-get install -y firefox-esr \
      && wget -O /tmp/driver.tar.gz https://github.com/mozilla/geckodriver/releases/download/v0.33.0/geckodriver-v0.33.0-linux64.tar.gz \
      && tar -C /usr/local/bin -xzf /tmp/driver.tar.gz \
      && bundle install
COPY ./features features/
ENV APP_URL="http://localhost:4567"
ENTRYPOINT ["bundle", "exec"]
CMD ["cucumber", "--publish-quiet"]

FROM base AS production
RUN bundle config set without "unit_test acceptance_test" \
      && bundle install
COPY hello.rb ./

ENV APP_ENV="production"
EXPOSE 4567
ENTRYPOINT ["bundle", "exec", "ruby", "hello.rb"]
CMD []
