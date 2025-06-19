FROM php:8.4-apache

# Installations de base
RUN apt-get update && apt-get install -y \
    git unzip \
    && docker-php-ext-install pdo pdo_mysql

# Installation de Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copie et installation des dépendances (optimisé pour le cache Docker)
WORKDIR /var/www/html
COPY ./composer.* ./
RUN composer install --no-dev  # Mode production sans les dépendances de dev
COPY . .


# Configuration Apache
RUN a2enmod rewrite
