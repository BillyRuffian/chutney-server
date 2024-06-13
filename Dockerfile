FROM ruby:3.3.3

WORKDIR /app

COPY . /app

RUN bundle install

CMD ["bundle", "exec", "puma"]