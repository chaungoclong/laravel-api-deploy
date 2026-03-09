FROM php:8.4-fpm-alpine

RUN apk add --no-cache \
    build-base \
    git \
    autoconf \
    shadow \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    libzip-dev \
    oniguruma-dev \
    icu-dev \
    fcgi \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd intl bcmath pdo_mysql pcntl zip \
    && pecl install redis \
    && docker-php-ext-enable redis

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

ARG UID=1000
ARG GID=1000

RUN groupadd --gid $GID api && \
    useradd --uid $UID --gid $GID api && \
    mkdir -p /home/api/.composer && \
    chown -R api:api /home/api

WORKDIR /var/www/html

USER api

EXPOSE 9000
