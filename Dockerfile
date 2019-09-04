FROM ruby:2.6.3
RUN apt-get update -qq && apt-get install -y build-essential \
    libxml2-dev \
    libxslt1-dev \
    libqtwebkit4 \
    libqt4-dev xvfb \ 
    mariadb-client \
    cron \
    curl && \
    curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install nodejs
ENV APP_HOME /app
RUN gem install bundler
WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/
RUN bundle install