#!/bin/bash
set -ex

sleep 10

readonly URL=${WORDPRESS_URL:-'localhost'}
readonly TITLE=${WORDPRESS_TITLE:-'My Wordpress'}

readonly ADM_USER=${WORDPRESS_ADMIN_USER:-'admin'}
readonly ADM_PASSWD=${WORDPRESS_ADMIN_PASSWORD:-'drowssap'}
readonly ADM_EMAIL="${WORDPRESS_ADMIN_EMAIL:-'admin@test.com'}"

readonly WP_HOME="${WORDPRESS_HOME:-'test.home.com'}"

readonly WP_DB="${WORDPRESS_DB:-'wordpress'}"
readonly WP_DB_USER="${WORDPRESS_DB_USER:-'wordpress_user'}"
readonly WP_DB_PASS="${WORDPRESS_DB_PASS:-'wp_password'}"
readonly WP_DB_HOST="${WORDPRESS_DB_HOST:-'mysql'}"
readonly TIMEOUT=30s
readonly wp="wp --allow-root"

dockerize -wait "tcp://${MYSQL_HOST:-mysql}:${MYSQL_PORT:-3306}" -timeout "$TIMEOUT"

apt-get update
apt-get install -y mysql-client

if [ -z "$WP_MASTER" ];
then
        $wp core download
        $wp core config \
                --dbhost="$WP_DB_HOST" \
                --dbuser="$WP_DB_USER" \
                --dbpass="$WP_DB_PASS" \
                --dbname="$WP_DB" \
                --skip-check \
                --force \
                --extra-php <<EOF
define( 'WP_SITEURL', 'https://' . \$_SERVER['HTTP_HOST']);
define( 'FORCE_SSL_ADMIN', 1);
ini_set(session.save_path, '/var/www/html/sessions');
if (isset(\$_SERVER['HTTP_X_FORWARDED_PROTO']) && \$_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https')
\$_SERVER['HTTPS'] = 'on';
EOF

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
        
else
        sleep 30
fi
apache2 -D FOREGROUND
