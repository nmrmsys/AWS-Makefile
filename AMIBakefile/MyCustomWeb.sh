
# timezone
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
cat <<'EOF' > /etc/sysconfig/clock
ZONE="Asia/Tokyo"
UTC=false
EOF

# postfix forward for AWS SES
yum -y install postfix cyrus-sasl-md5 mailx
#cat <<'EOF' > /etc/postfix/sasl_passwd
#email-smtp.us-east-1.amazonaws.com:25 <access_key>:<secret_key>
#EOF
#postmap /etc/postfix/sasl_passwd
#cat <<'EOF' >> /etc/postfix/main.cf
#
## added settings
#myhostname = myhostname.mydomain
#mydomain = mydomain
#myorigin = $mydomain
#relayhost = email-smtp.us-east-1.amazonaws.com:587
#smtp_sasl_auth_enable = yes
#smtp_sasl_security_options = noanonymous
#smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
#smtp_use_tls = yes
#smtp_tls_security_level = encrypt
#smtp_tls_note_starttls_offer = yes
#EOF
service sendmail stop
yum -y remove sendmail
chkconfig postfix on
service   postfix start

# mysql
yum -y install mysql-server
chkconfig mysqld on
service   mysqld start

# php
yum -y install php php-mbstring php-pdo

# SSL Certificate Let's Encrypt certbot
wget -O /usr/local/bin/certbot-auto https://dl.eff.org/certbot-auto
chmod +x /usr/local/bin/certbot-auto
#certbot-auto certonly --agree-tos --non-interactive -m admin@myhostname.mydomain --webroot -w /var/www/html -d myhostname.mydomain
#certbot-auto renew -q --no-self-upgrade --post-hook "service httpd reload"

# apache
yum -y install httpd mod_ssl
chkconfig httpd on
service   httpd start
