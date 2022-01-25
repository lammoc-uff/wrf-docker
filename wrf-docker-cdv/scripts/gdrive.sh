#!/bin/bash

# TODO(ericmiguel): remover redundância dessas variáveis ao longo dos scripts
SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PARENTPATH=`dirname $SCRIPTPATH`


########################################################################################
# Baixa o Gdrive a partir do seu repositório Github, decompacta e permite execução.
# Globals:
#   PARENTPATH
# Arguments:
#   None
########################################################################################
instalar () {
    wget "https://github.com/prasmussen/gdrive/releases/download/2.1.1/gdrive_2.1.1_linux_386.tar.gz"
    tar -zxvf gdrive_2.1.1_linux_386.tar.gz -C "$PARENTPATH/"
    rm gdrive_2.1.1_linux_386.tar.gz
    chmod +x "$PARENTPATH/gdrive"
}


########################################################################################
# Executa a autenticação do Gdrive na sua conta Google
# Globals:
#   PARENTPATH
# Arguments:
#   None
########################################################################################
autenticar () {
    "$PARENTPATH/gdrive" about
}


########################################################################################
# Modelo, ferramentas relativas e bibliotecas necessárias para instalação. 
# 
# Espera-se que os nomes abaixo existem em qualquer lugar do seu Google Drive.
# Tanto faz o canto, pois o script usa o ID único dos arquivos, mas os nomes
# precisam ser exatos.
# 
# obs.: não podem existir outros arquivos com o mesmo nome no Google Drive.
########################################################################################
ARQUIVOS=(
    "WRFV4.0.tar.gz"
    "WPSV4.0.tar.gz"
    "ARWpost_V3.tar.gz"
    "zlib-1.2.7.tar.gz"
    "netcdf-4.1.3.tar.gz"
    "jasper-1.900.1.tar.gz"
    "libpng-1.2.50.tar.gz"
    "mpich-3.0.4.tar.gz"
)


########################################################################################
# Baixa o modelo, ferramentas relativas e bibliotecas necessárias para instalação.
# Globals:
#   PARENTPATH
#   ARQUIVOS
# Arguments:
#   1. Diretório de persistência dos arquivos
########################################################################################
download () {
    echo "baixando tudo: relaxou, pois pode demorar até o output começar a aparecer..."
    for i in "${ARQUIVOS[@]}"; do
        ID=$($PARENTPATH/gdrive list -m 10 --query "name contains '$i'" |\
            awk '{print $1}' |\
            awk 'NR==2')
        $PARENTPATH/gdrive download $ID --skip --path $PARENTPATH/$1
    done
    echo "todas as dependências foram baixadas."
}


"$@"