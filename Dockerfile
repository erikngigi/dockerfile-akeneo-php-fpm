FROM php:8.1.31-fpm

# Maintainer details
LABEL Maintainer="Eric Ngigi <ericmosesngigi@gmail.com>" \
  Description="PHP-FPM v8.1 with essential extensions for Akeneo."

# Set working directory
RUN mkdir -p /var/www/html/akeneo
WORKDIR /var/www/html/akeneo

# Install system dependencies, clean apt cache
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential libpng-dev libjpeg62-turbo-dev libfreetype6-dev locales zip jpegoptim optipng pngquant gifsicle vim unzip git curl \
  libonig-dev libzip-dev libgd-dev libssl-dev libxml2-dev libreadline-dev libxslt-dev supervisor bash mycli gnupg2 libmagickwand-dev \
  libmagickcore-dev nodejs npm less && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

# Install and enable third-party PHP extensions via PECL
RUN pecl install imagick apcu swoole && \
  docker-php-ext-enable imagick apcu swoole

# Configure and install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
  docker-php-ext-install \
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

# Install Yarn globally using npm
RUN npm install --global yarn

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add Composer to the PATH
ENV PATH="/usr/local/bin:$PATH"

# Create application user
RUN groupadd -g 1000 akeneo && \
  useradd -u 1000 -ms /bin/bash -g akeneo akeneo && \
  chown -R akeneo:akeneo /var/www/html/akeneo

# Switch to non-root user
USER akeneo

# Expose port 9100 and start php-fpm
EXPOSE 9100
CMD ["php-fpm"]
