FROM php:8.1-fpm

# Set working directory
WORKDIR /var/www/akeneo/pim-community-standard

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential libpng-dev libjpeg62-turbo-dev libfreetype6-dev locales zip jpegoptim optipng pngquant gifsicle vim unzip git curl \
    libonig-dev libzip-dev libgd-dev libssl-dev libxml2-dev libreadline-dev libxslt-dev supervisor bash mycli gnupg2 \
    libmagickwand-dev libmagickcore-dev nodejs npm less\
 && pecl install imagick apcu swoole \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Install Yarn
RUN npm install --global yarn && yarn --version

# Update browerlist using npm
RUN npm i browserslist

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install \
    bcmath \
    calendar \
    exif \
    gd \
    gettext \
    intl \
    mbstring \
    mysqli \
    opcache \
    pcntl \
    pdo_mysql \
    soap \
    sockets \
    xsl \
    xml \
    zip \
 && docker-php-ext-enable \
    mysqli \
    imagick \
    apcu \
    swoole

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add Composer to the PATH
ENV PATH="/usr/local/bin:$PATH"

# Create application user
RUN groupadd -g 1000 app && \
    useradd -u 1000 -ms /bin/bash -g app app && \
    chown -R app:app /var/www/akeneo

# Switch to non-root user
USER app

# Expose port 9000 and start php-fpm
EXPOSE 9000
CMD ["php-fpm"]
