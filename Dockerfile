FROM php:8.1-fpm

# Set working directory
WORKDIR /var/www/akeneo/pim-community-standard

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential libpng-dev libjpeg62-turbo-dev libfreetype6-dev locales zip jpegoptim optipng pngquant gifsicle vim unzip git curl \
    libonig-dev libzip-dev libgd-dev libssl-dev libxml2-dev libreadline-dev libxslt-dev supervisor bash mycli gnupg2 libmagickwand-dev \
    libmagickcore-dev nodejs npm less

# Install third party extensions
RUN pecl install imagick apcu swoole

# Clear out the local repository of retrieved packages
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install yarn globally using npm
RUN npm install --global yarn

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
    zip

# Enable the third party extensions installed using pecl
# RUN docker-php-ext-enable \
#     acpu \
#     imagick \
#     mysqli \
#     swoole

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add Composer to the PATH
ENV PATH="/usr/local/bin:$PATH"

# Create application user
RUN groupadd -g 1000 akeneo && \
    useradd -u 1000 -ms /bin/bash -g akeneo akeneo && \
    chown -R akeneo:akeneo /var/www/akeneo

# Switch to non-root user
USER akeneo

# Expose port 9000 and start php-fpm
EXPOSE 9000
CMD ["php-fpm"]
