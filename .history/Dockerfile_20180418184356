FROM php:7.1-apache

ENV ACCEPT_EULA=Y

# Microsoft SQL Server Prerequisites
RUN apt-get update \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/8/prod.list \
        > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get install -y --no-install-recommends \
        locales \
        apt-transport-https \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
        msodbcsql \
        unixodbc-dev

RUN apt-get install -y libpng-dev

RUN docker-php-ext-install gd mbstring pdo pdo_mysql \
    && pecl install sqlsrv pdo_sqlsrv xdebug \
    && docker-php-ext-enable sqlsrv pdo_sqlsrv xdebug gd

ADD www /var/www/html
ADD apache-config.conf /etc/apache2/sites-available/000-default.conf
ADD apache2.conf /etc/apache2/apache2.conf
COPY index.php /var/www/html

RUN chmod 777 -R /var/www/html/storage && chmod 777 -R /var/www/html/bootstrap/cache
RUN php artisan config:clear && php artisan config:cache
RUN a2enmod rewrite

# INSTALL Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer update

# INSTALL Excel
RUN composer require maatwebsite/excel