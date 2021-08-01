#!/bin/bash

# TODO(ericmiguel): remover redundância dessas variáveis ao longo dos scripts
SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PARENTPATH=`dirname $SCRIPTPATH`


echo "organizando diretórios..."
mv "$PARENTPATH/downloads/"wrf* "$PARENTPATH/paralelo"
mv "$PARENTPATH/downloads/"arw* "$PARENTPATH/paralelo"
mv "$PARENTPATH/downloads/"wps* "$PARENTPATH/paralelo"
mv "$PARENTPATH/downloads/"*.tar.gz "$PARENTPATH/paralelo/bibliotecas"

echo "descompactando modelo..."
tar -zxvf "$PARENTPATH/paralelo/"wrf* -C "$PARENTPATH/paralelo/"
rm "$PARENTPATH/paralelo/"wrf*

# TODO(ericmiguel): descompactar ARW e WPS aqui

echo "descompactando dependências..."
ARQS="$PARENTPATH/paralelo/bibliotecas/"*.gz
for arq in $ARQS; do
    tar -zxvf $arq -C "$PARENTPATH/paralelo/bibliotecas/"
    rm $arq
done

