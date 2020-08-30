FROM php:7.3-fpm
 
ARG WEB_USER
ARG WEB_GROUP
ARG PHP_ROOT_DIR
ARG PHP_ENABLE_XDEBUG=0

ENV DEBIAN_FRONTEND=noninteractive
#WORKAROUND TILL UPDATE

RUN apt-get update -y && \
    apt-get -y install gnupg2 --allow-unauthenticated
RUN set -eux; \
    \
    for key in $GPG_KEYS; do \
        gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
    done; 
# WORKAROUND END

COPY image-files/ /
RUN chmod 1777 /tmp
RUN export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS" 
RUN apt-get -y install \
        libsqlite3-dev  \
        git \
        curl \
        libfreetype6-dev \
        libcurl3-dev \
        libicu-dev \
        libfreetype6-dev \
        libjpeg-dev \
        libpng-dev \
        libjpeg-dev \
        libjpeg62-turbo-dev \
        libmagickwand-dev \
        libmagickcore-6.q16-3-extra \
        libmagickcore-dev \
        imagemagick \
        libpq-dev \
        libpng-dev \
        libxml2-dev \
        zlib1g-dev \
        libzip-dev \
        unzip \
        ssh \
        libsqlite3-dev  \
        --no-install-recommends && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install PHP extensions required for Framework
RUN docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-configure bcmath && \
    docker-php-ext-install \
        soap \
        zip \
        curl \
        bcmath \
        exif \
        gd \
        iconv \
        intl \
        mbstring \
        opcache \
        pdo_sqlite \
        pdo_mysql \
        pdo_pgsql \
        mysqli

## Install PECL extensions
## see http://stackoverflow.com/a/8154466/291573) for usage of `printf`
RUN printf "\n" | pecl install imagick && \
    docker-php-ext-enable imagick 

# Environment settings
ENV PHP_ENABLE_XDEBUG=${PHP_ENABLE_XDEBUG} \
    PATH=/app:/app/vendor/bin:/root/.composer/vendor/bin:$PATH \
    TERM=linux \
    VERSION_PRESTISSIMO_PLUGIN=^0.3.7 \
    COMPOSER_ALLOW_SUPERUSER=1

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- \
        --filename=composer.phar \
        --install-dir=/usr/local/bin && \
    composer clear-cache

RUN chmod 700 \
        /usr/local/bin/docker-php-entrypoint  \
        /usr/local/bin/composer

# Install composer plugins
RUN composer global require --optimize-autoloader \
        "hirak/prestissimo" && \
    composer global dumpautoload --optimize && \
    composer clear-cache
