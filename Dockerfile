FROM ruby:2.6.5

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

RUN mkdir /myapp
WORKDIR /myapp

COPY Gemfile /myapp/
COPY Gemfile.lock /myapp/
RUN bundle install

EXPOSE 3000

COPY . /myapp

# CMD ["rails", "server", "-b", "0.0.0.0"]
