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
mv "$PARENTPATH/scripts/"baixa_gfs_0p25.sh "$PARENTPATH/../docker/volumes/GFS_volume"

# Criando diretorio no Volume para receber os arquivos de saída do modelo
sudo docker volume create WRF_out_volume

# Criando diretorio que receberá as saídas do modelo e será linkado com volume
cd "$PARENTPATH/paralelo/WRF"
mkdir WRF_out

################# INSTALAÇÃO DO PÓS-PROCESSAMENTO - FORA DO CONTAINER ##############

echo "instalando ARWpost..."

cd "$PARENTPATH/paralelo/ARWpost"
#3 = opção 3 ( gfortran)
echo "3" | ./configure
sed -i '38d' configure.arwp
sed -i '38i CPP             =       /lib/cpp -P -traditional' configure.arwp

# editando Makefile

cd "$PARENTPATH/paralelo/ARWpost/src"
sed -i '19d' Makefile
sed -i '19i\                -L$(NETCDF)/lib -I$(NETCDF)/include  -lnetcdff -lnetcdf' Makefile

# Copiamos a pasta include do netcdf para o diretório raiz do WRF e depois compilamos o ARWpost

cd "$PARENTPATH/paralelo/bibliotecas/netcdf-4.1.3"
cp -r include ../../
cd "$PARENTPATH/paralelo/ARWpost"
./compile

# Download do GrADS e descompactação
echo "Baixando GrADS.."
cd "$PARENTPATH/paralelo"
wget "ftp://cola.gmu.edu/grads/2.0/grads-2.0.2-bin-CentOS5.8-x86_64.tar.gz"
tar -zxvf grads-2.0.2-bin-CentOS5.8-x86_64.tar.gz
rm grads-2.0.2-bin-CentOS5.8-x86_64.tar.gz

# InstalaÇÃo do GrADS
cd "$PARENTPATH/paralelo"
mv grads-2.0.2 /opt/
cd
sed -i "20i export PATH=/opt/grads-2.0.2/bin:$PATH" .bashrc