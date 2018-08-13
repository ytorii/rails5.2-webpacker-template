FROM ruby:2.5.1-alpine

RUN apk update && apk upgrade && apk add --update --no-cache sqlite-dev nodejs alpine-sdk tzdata

RUN mkdir /app
WORKDIR /app

ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock

RUN bundle install --path vendor/bundle -j4
ADD . /app

ENV PATH=/root/.yarn/bin:$PATH
RUN apk add --virtual build-yarn curl && \
    curl -o- -L https://yarnpkg.com/install.sh | sh && \
    apk del build-yarn

RUN yarn

EXPOSE 3000

CMD [ "bundle", "exec", "rails", "s", "-p", "3000", "-b", "0.0.0.0" ]
