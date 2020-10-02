FROM php:7.4-apache

ARG APACHE_DOCUMENT_ROOT
ENV APACHE_DOCUMENT_ROOT=$APACHE_DOCUMENT_ROOT

# make sure apt is up to date
RUN apt-get update --fix-missing
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
      procps \
      vim \
      nano \
      git \
      unzip \
      libicu-dev \
      zlib1g-dev \
      libxml2 \
      libxml2-dev \
      libreadline-dev \
      supervisor \
      cron \
      curl \
      libzip-dev \
      librabbitmq-dev \
      build-essential \
      libssl-dev \
      libpng-dev \
      libjpeg-dev \
      libfreetype6-dev \
      libxslt-dev

RUN apt-get install -y git

#Install and configure php
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && docker-php-ext-install gd
RUN docker-php-ext-configure intl && docker-php-ext-install intl
RUN docker-php-ext-install mysqli pdo_mysql
RUN docker-php-ext-install xsl
RUN pecl install amqp

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN apt-get install -y zip unzip
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

## Configure apache
# without the following line we get "AH00558: apache2: Could not reliably determine the server's fully qualified domain name"
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
# autorise .htaccess files
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
# Change apache root path
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
#Enable apache rewrites
RUN a2enmod rewrite


#Cleanup
RUN docker-php-ext-enable amqp \
        && rm -rf /tmp/* \
        && rm -rf /var/list/apt/* \
        && rm -rf /var/lib/apt/lists/* \
        && apt-get clean
