FROM ruby:2.6.3
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list | tee /etc/apt/sources.list.d/msprod.list && \
    apt-get update -qq && \
    ACCEPT_EULA=Y apt-get install -y \
    build-essential \
    libqt4-dev xvfb \
    libqtwebkit4 \
    libxml2-dev \
    libxslt1-dev \
    locales \
    mariadb-client \
    mssql-tools \
    nodejs \
    unixodbc-dev
# Requirements to install mssql-tools properly
# https://github.com/Microsoft/mssql-docker/issues/163
ENV PATH="/opt/mssql-tools/bin:${PATH}"
RUN echo "nb_NO.UTF-8 UTF-8" > /etc/locale.gen && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen
ENV APP_HOME /app
RUN gem install bundler
WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/
RUN bundle install