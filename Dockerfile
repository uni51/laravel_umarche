FROM php:7.4-fpm-alpine

# 基本的なあれこれとgd,node,npm,supervisor
RUN apk upgrade --update && \
    apk --no-cache --update add \
    icu-dev autoconf make g++ gcc bash git zip unzip vim\
    coreutils \
    freetype-dev \
    libjpeg-turbo-dev \
    libltdl \
    libmcrypt-dev \
    libpng-dev \
    oniguruma-dev \
    nodejs npm

# php extension
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    bcmath opcache sockets pdo_mysql

# install Composer
RUN docker-php-ext-install pdo pdo_mysql
RUN curl -sS https://getcomposer.org/installer | php -- \
        --install-dir=/usr/local/bin --filename=composer

WORKDIR /app
COPY . .
RUN composer install

CMD php artisan serve --host=0.0.0.0
