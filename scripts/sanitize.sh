#!/bin/sh

# SERVIÇOS

echo "Restarting elasticsearch"
systemctl restart elasticsearch
sleep 60

echo "Restarting php7.4-fpm"
systemctl restart php7.4-fpm
sleep 60

echo "Restarting memcached"
systemctl restart memcached
sleep 60

echo "Restarting nginx"
systemctl restart nginx
sleep 60

echo "Restarting atom-worker"
systemctl reset-failed atom-worker
systemctl restart atom-worker

sleep 180

# SYMFONY

(
cd /usr/share/nginx/atom

echo "Symfony digitalobject:extract-text"
php symfony digitalobject:extract-text
sleep 60

echo "Symfony propel:build-nested-set"
php symfony propel:build-nested-set
sleep 60

echo "Symfony propel:generate-slugs"
php symfony propel:generate-slugs
sleep 60

echo "Symfony cache:xml-representations"
php symfony cache:xml-representations
sleep 60

echo "Symfony cc"
php symfony cc
sleep 60

echo "Symfony search:populate"
php symfony search:populate
sleep 60

# A Re-geração de derivadas de acesso foi desativada por geralmente
# tomar muito tempo e inviabilizar o uso do servidor, claro, dependendo
# das dimensões de memória, cpu e objetos digitais.
#
# Recomenda-se que esse comando seja executado nos finais de semana.
# php symfony digitalobject:regen-derivatives -f

)
