FROM docker.io/library/ruby:3.2.2 AS base
WORKDIR /app
COPY Gemfile Gemfile.lock ./

FROM base AS development
RUN bundle install
COPY hello.rb ./
COPY ./features features/
ENTRYPOINT ["bundle", "exec"]
CMD ["rspec"]

FROM base AS production
RUN bundle config set without "unit_test acceptance_test" \
      && bundle install
COPY hello.rb ./

ENV APP_ENV="production"
EXPOSE 4567
ENTRYPOINT ["bundle", "exec", "ruby", "hello.rb"]
CMD []
