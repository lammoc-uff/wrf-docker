#!/bin/bash

# TODO(ericmiguel): remover redundância dessas variáveis ao longo dos scripts
SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PARENTPATH=`dirname $SCRIPTPATH`


echo "organizando diretórios..."
mv "$PARENTPATH/downloads/"wrf* "$PARENTPATH/paralelo"
mv "$PARENTPATH/downloads/"arw* "$PARENTPATH/paralelo"
mv "$PARENTPATH/downloads/"wps* "$PARENTPATH/paralelo"
mv "$PARENTPATH/downloads/"*.tar.gz "$PARENTPATH/paralelo/bibliotecas"
cd "$PARENTPATH/paralelo" && mkdir GEOG_files   #arquivos geográficos do volume sem sobrepor os arq. do paralelo

echo "descompactando modelo..."
tar -zxvf "$PARENTPATH/paralelo/"wrf* -C "$PARENTPATH/paralelo/"
rm "$PARENTPATH/paralelo/"wrf*

# Descompactar ARW e WPS

echo "descompactando WPS..."
tar -zxvf "$PARENTPATH/paralelo/"wps* -C "$PARENTPATH/paralelo/"
rm "$PARENTPATH/paralelo/"wps*

echo "descompactando ARWPost..."
tar -zxvf "$PARENTPATH/paralelo/"arw* -C "$PARENTPATH/paralelo/"
rm "$PARENTPATH/paralelo/"arw*

echo "descompactando dependências..."
ARQS="$PARENTPATH/paralelo/bibliotecas/"*.gz
for arq in $ARQS; do
    tar -zxvf $arq -C "$PARENTPATH/paralelo/bibliotecas/"
    rm $arq
done

# baixando dados geograficos
echo "Criando Volume para os dados geográficos.."
sudo docker volume create GEOG_volume
cd "$PARENTPATH/../docker/volumes/GEOG_volume"
echo "Baixando dados geograficos..."
sudo wget "https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_high_res_mandatory.tar.gz"
sudo tar -zxvf geog_high_res_mandatory.tar.gz #cria um diretório WPS_GEOG

# Criando diretorio do GFS e Volume para receber os arquivos de entrada
cd "$PARENTPATH/paralelo/WRF" && mkdir GFS
sudo docker volume create GFS_volume

# Criando diretorio no Volume para receber os arquivos de saída do modelo
sudo docker volume create WRF_out_volume

# Criando diretorio que receberá as saídas do modelo e será linkado com volume
cd "$PARENTPATH/paralelo/WRF"
mkdir WRF_out