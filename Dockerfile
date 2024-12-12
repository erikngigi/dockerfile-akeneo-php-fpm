FROM php:8.1-fpm

# Set working directory
WORKDIR /var/www/akeneo

# Install dependencies
RUN apt-get update && apt-get install -y \
  build-essential libpng-dev libjpeg62-turbo-dev \
  libfreetype6-dev locales zip jpegoptim optipng \
  pngquant gifsicle vim unzip git curl libonig-dev \
  libzip-dev libgd-dev libjpeg-dev libssl-dev \
  libxml2-dev libreadline-dev libxslt-dev \
  supervisor bash mycli gnupg2 libmagickwand-dev \
  libmagickcore-dev nodejs npm

RUN pecl install imagick && pecl install apcu

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update && apt install -y yarn

# Install the PHP bcmath extension
RUN docker-php-ext-install bcmath

# Install for image manipulation
RUN docker-php-ext-install exif

# Install the PHP graphics library
RUN docker-php-ext-configure gd \
  --with-freetype \
  --with-jpeg
RUN docker-php-ext-install gd

# Install the PHP intl extention
RUN docker-php-ext-install intl

# Install the PHP mysqli extention
RUN docker-php-ext-install mysqli && \
  docker-php-ext-enable mysqli

# Install the PHP opcache extention
RUN docker-php-ext-install opcache

# Install the PHP pcntl extention
RUN docker-php-ext-install pcntl

# Install the PHP pdo_mysql extention
RUN docker-php-ext-install pdo_mysql

# Install the PHP zip extention
RUN docker-php-ext-install zip

# Install the PHP xsl extention
RUN docker-php-ext-install xsl

# Install the PHP sockets extention
RUN docker-php-ext-install sockets

# Install the PHP soap extention
RUN docker-php-ext-install soap

# Install the PHP curl extension
# RUN docker-php-ext-install curl

# Install the PHP xml extension
RUN docker-php-ext-install xml

# Install the PHP zip extension
RUN docker-php-ext-install zip

# Install the PHP mbstring extension
RUN docker-php-ext-install mbstring

# Install the PHP imagick extension
RUN docker-php-ext-enable imagick

# Install the PHP acpu extension
RUN docker-php-ext-enable apcu

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add Composer to the PATH
ENV PATH="$PATH:/usr/local/bin"

# Add user for laravel application
RUN groupadd -g 1000 app
RUN useradd -u 1000 -ms /bin/bash -g app app

# Copy existing application directory permissions
RUN chown=app:app . /var/www/akeneo

# Change current user to www
USER app

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
