FROM php:7.1
ARG DEBIAN_FRONTEND=noninteractive

# system dependecies
RUN apt-get update && apt-get install -y \
  apt-utils \
  libicu-dev \
  git \
  vim \
  libicu-dev \
  libpq-dev \
  unzip \
  zlib1g-dev \
  gnupg

# PHP dependencies
RUN docker-php-ext-install \
   intl \
   pcntl \
   mbstring \
   pdo \
   pdo_odbc \
   pdo_mysql \
   pdo_pgsql \
   zip

RUN pecl config-set php_ini "${PHP_INI_DIR}/php.ini"

RUN pecl install pdo_sqlsrv xdebug

RUN docker-php-ext-enable xdebug pdo_sqlsrv

# Sql Server
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/10/prod.list | tee /etc/apt/sources.list.d/mssql-server-2017.list

#RUN curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN . ~/.bashrc

# composer
RUN curl -sS https://getcomposer.org/installer | php && \
	  mv composer.phar /usr/local/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER=1

WORKDIR /src
