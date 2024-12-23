FROM php:8.1-fpm

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential libpng-dev libjpeg62-turbo-dev libfreetype6-dev locales zip jpegoptim optipng pngquant gifsicle vim unzip git curl \
    libonig-dev libzip-dev libgd-dev libssl-dev libxml2-dev libreadline-dev libxslt-dev supervisor bash mycli gnupg2 libmagickwand-dev \
    libmagickcore-dev nodejs npm less

# Clear out the local repository of retrieved packages
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

############################################
# PHP Extensions
############################################
# Install the PHP shared memory driver
RUN pecl install APCu && \
    docker-php-ext-enable apcu

# Install the PHP bcmath extension
RUN docker-php-ext-install bcmath

# Install for image manipulation
RUN docker-php-ext-install exif

# Install the PHP gd extension
RUN docker-php-ext-install gd

# Install the PHP imagick extension for image manipulation
RUN pecl install imagick && \
    docker-php-ext-enable imagick

# Install the PHP intl extension
RUN docker-php-ext-install intl

# Install the PHP mbstring extension
RUN docker-php-ext-install mbstring

# Install the PHP mysqli extension
RUN docker-php-ext-install mysqli && \
    docker-php-ext-enable mysqli

# Install the PHP opcache extension
RUN docker-php-ext-enable opcache

# Install the PHP pcntl extension
RUN docker-php-ext-install pcntl

# Install the PHP pdo_mysql extension
RUN docker-php-ext-install pdo_mysql

# Install the PHP redis driver
RUN pecl install redis && \
    docker-php-ext-enable redis

# Install XDebug but without enabling
RUN pecl install xdebug

# Install the PHP xml extension
RUN docker-php-ext-install xml

# Install the PHP zip extension
RUN docker-php-ext-install zip

# Install yarn globally using npm
RUN npm install --global yarn

#####################################
# Composer
#####################################
RUN curl -s http://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Set working directory
WORKDIR /var/www/akeneo/pim-community-standard

# Create application user
RUN groupadd -g 1000 akeneo && \
    useradd -u 1000 -ms /bin/bash -g akeneo akeneo && \
    chown -R akeneo:akeneo /var/www/akeneo

# Switch to non-root user
USER akeneo

# Expose port 9000 and start php-fpm
EXPOSE 9000
CMD ["php-fpm"]
