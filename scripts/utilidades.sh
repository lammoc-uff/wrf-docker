#!/bin/bash

# TODO(ericmiguel): remover redundância dessas variáveis ao longo dos scripts
SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PARENTPATH=`dirname $SCRIPTPATH`


########################################################################################
# Cria a estrutura de diretórios necessária
# Globals:
#   PARENTPATH
# Arguments:
#   None
########################################################################################
criar-diretorios(){
    mkdir -p "${PARENTPATH}/paralelo/bibliotecas"
    mkdir -p "${PARENTPATH}/downloads"
    echo "estrutura de diretórios criada."
}

########################################################################################
# Renomeia os arquivos de um diretório para caixa baixa
# Globals:
#   None
# Arguments:
#   1. Diretório alvo
# Use example:
#   bash utilidades.sh renomear-arquivos-diretorio [dir]
########################################################################################
renomear-arquivos-diretorio(){
    for i in $( ls $1 ); do
        mv -i "$1/$i" `echo "$1/$i" | tr 'A-Z' 'a-z'` || echo ""
    done
}


"$@"