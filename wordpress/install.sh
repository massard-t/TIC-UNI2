#!/bin/bash
set -ex

readonly URL=${WORDPRESS_URL:-'localhost'}
readonly TITLE=${WORDPRESS_TITLE:-'Wordpress site'}
readonly ADM_USER=${WORDPRESS_ADMIN_USER:-'admin'}
readonly ADM_PASSWD=${WORDPRESS_ADMIN_PASSWORD:-'drowssap'}
readonly ADM_EMAIL="${WORDPRESS_ADMIN_EMAIL:-'admin@test.com'}"
readonly WP_HOME="${WORDPRESS_HOME:-'test.home.com'}"
readonly WP_DB="${WORDPRESS_DB:-'wordpress'}"
readonly WP_DB_USER="${WORDPRESS_DB_USER:-'wordpress_user'}"
readonly WP_DB_PASS="${WORDPRESS_DB_PASS:-'wp_password'}"
readonly WP_DB_HOST="${WORDPRESS_DB_HOST:-'mysql'}"
readonly WP_URL="https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar"

apt-get update
curl -s -o /usr/bin/wp "$WP_URL" \
chmod +x /usr/bin/wp
apt-get install -y mysql-client

wp="wp --allow-root"
$wp core download
$wp config create \
        --dbname="$WP_DB" \
        --dbuser="$WP_DB_USER" \
        --dbpass="$WP_DB_PASS" \
        --dbhost="$WP_DB_HOST"
$wp core install \
  --url="$URL" \
  --title="$TITLE" \
  --admin_user="$ADM_USER" \
  --admin_password="$ADM_PASSWD" \
  --admin_email="$ADM_EMAIL"

$wp option update permalink_structure '/%year%/%monthnum%/%day%/%postname%/'
$wp option update home "https://$WP_HOME"
$wp option update siteurl "https://$WP_HOME"

if [ ! -e .htaccess ];
then
  cat > .htaccess <<- 'EOF'
  # Wordpress
  <IfModule mode_rewrite.c>
  RewriteEngin On
  RewriteBase /
  RewriteRule ^index\.php$ - [L]
  RewriteCond %{REQUEST_FILENAME} !-f
  RewriteCond %{REQUEST_FILENAME} !-d
  RewriteRule . /index.php [L]
  </IfModule>
  # /Wordpress
EOF
  chown www-data:www-data .htaccess
fi
chown -R www-data:www-data /var/www/html

