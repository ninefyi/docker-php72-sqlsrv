FROM php:7.2.5-apache

ENV ACCEPT_EULA=Y

# Update gnupg
RUN apt-get update && apt-get install -my wget gnupg

# Microsoft SQL Server Prerequisites
# RUN apt-get update \
#    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
#    && curl https://packages.microsoft.com/config/debian/8/prod.list \
#        > /etc/apt/sources.list.d/mssql-release.list \
#    && apt-get install -y --no-install-recommends \
#        locales \
#        apt-transport-https \
#    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
#    && locale-gen \
#    && apt-get update \
#    && apt-get -y --no-install-recommends install \
#        msodbcsql \
#        unixodbc-dev

RUN apt-get install -y libpng-dev libzip-dev zip

RUN docker-php-ext-configure zip --with-libzip

# RUN docker-php-ext-install zip gd mbstring pdo pdo_mysql \
#    && pecl install sqlsrv pdo_sqlsrv xdebug \
#    && docker-php-ext-enable sqlsrv pdo_sqlsrv xdebug gd zip

RUN docker-php-ext-install zip gd mbstring pdo pdo_mysql \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug gd zip

ADD www /var/www/html
ADD apache-config.conf /etc/apache2/sites-available/000-default.conf
ADD apache2.conf /etc/apache2/apache2.conf
# COPY index.php /var/www/html

RUN a2enmod rewrite

# INSTALL Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
# RUN composer update

# INSTALL LARAVEL
# RUN composer create-project --prefer-dist laravel/laravel .
RUN chmod 777 -R /var/www/html/storage && chmod 777 -R /var/www/html/bootstrap/cache
RUN php artisan config:clear && php artisan config:cache

# INSTALL Excel
# RUN composer require maatwebsite/excel
