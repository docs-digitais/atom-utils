#!/bin/bash

printf '%.1s' ={1..80}
echo ""
echo "Iniciando a execução da sanitização do AtoM."
printf '%.1s' ={1..80}
echo -e "\n"

# Utils
pad() {
  echo ""
  printf '%.80s\n' "$1 $(printf '%.1s' .{1..80})"
  echo ""
}

# Entrar no diretório do atom.
pushd /usr/share/nginx/atom

# SERVIÇOS

pad "[REINICIANDO] ELASTICSEARCH"
systemctl restart elasticsearch

pad "[REINICIANDO] PHP"
systemctl restart php7.2-fpm

pad "[REINICIANDO] MEMCACHED"
systemctl restart memcached

pad "[REINICIANDO] NGINX"
systemctl restart nginx

pad "[REINICIANDO] ATOM WORKER"
systemctl restart atom-worker

# SYMFONY

pad "[SYMFONY] REGERAR DERIVATIVAS DE ACESSO"
php symfony digitalobject:regen-derivatives -f

pad "[SYMFONY] REINDEXAR PDFS"
php symfony digitalobject:extract-text

pad "[SYMFONY] REGERAR NESTED SET"
php symfony propel:build-nested-set

pad "[SYMFONY] GERAR SLUGS"
php symfony propel:generate-slugs

pad "[SYMFONY] CACHE EAD-XML"
php symfony cache:xml-representations

pad "[SYMFONY] LIMPAR CACHE"
php symfony cc

pad "[SYMFONY] POPULAR INDEX"
php symfony search:populate

pad "[PRONTO] SANITIZAÇÃO COMPLETA"

popd