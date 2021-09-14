#!/bin/bash

################# INSTALAÇÃO DO PÓS-PROCESSAMENTO - FORA DO CONTAINER ##############
echo "instalando netcdf..."
cd "$PARENTPATH/paralelo/bibliotecas/netcdf-4.1.3"
./configure --prefix=/usr/local/netcdf --disable-dap --disable-netcdf-4 --disable-shared
make && make install

export NETCDF = /usr/local/netcdf
export NETCDF_classic = 1

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
export PATH="/opt/grads-2.0.2/bin:$PATH"
cd "$PARENTPATH/paralelo"
mv grads-2.0.2 /opt/
cd
sed -i "20i export PATH=/opt/grads-2.0.2/bin:$PATH" .bashrc