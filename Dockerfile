FROM docker.io/library/ruby:3.2.2 AS gemfiles
WORKDIR /app
RUN bundle config set --global frozen 1
COPY Gemfile Gemfile.lock ./
ENTRYPOINT ["bundle", "exec"]
CMD ["ruby", "hello.rb"]

FROM ghcr.io/instrumentisto/geckodriver:120.0.1 AS gecko

FROM gemfiles AS web-browser
RUN apt-get update && apt-get install -y firefox-esr
COPY --from=gecko --chown=root:root --chmod=0755 /usr/local/bin/geckodriver /usr/local/bin/

FROM web-browser AS acceptance-test
RUN bundle config set without "unit_test" && bundle install
COPY ./features features/
#USER 1234:1234 # TODO: get selenium working without being root
CMD ["cucumber", "--publish-quiet"]

FROM gemfiles AS unit-test
ENV RUBOCOP_CACHE_ROOT="/tmp/rubocop"
RUN bundle config set without "acceptance_test" \
      && bundle install \
      && mkdir $RUBOCOP_CACHE_ROOT \
      && chmod 1777 $RUBOCOP_CACHE_ROOT
COPY hello.rb ./
COPY ./features features/
USER 1234:1234
CMD ["rspec"]

FROM gemfiles AS development
RUN bundle config set --global frozen 0 && bundle install
USER 1234:1234
EXPOSE 4567

FROM gemfiles AS production
RUN bundle config set without "unit_test acceptance_test" \
      && bundle install
COPY hello.rb ./
USER 1234:1234
ENV APP_ENV="production"
EXPOSE 4567
