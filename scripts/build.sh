#!/bin/bash

# TODO(ericmiguel): remover redundância dessas variáveis ao longo dos scripts
SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PARENTPATH=`dirname $SCRIPTPATH`

# dependências
echo "instalando MPI..."
cd "$PARENTPATH/paralelo/bibliotecas/mpich-3.0.4"
./configure --prefix=/usr/local/mpich
make && make install

echo "instalando zlib..."
cd "$PARENTPATH/paralelo/bibliotecas/zlib-1.2.7"
./configure --prefix=/usr/local/grib2
make && make install

echo "instalando libpng..."
cd "$PARENTPATH/paralelo/bibliotecas/libpng-1.2.50"
./configure --prefix=/usr/local/grib2
make && make install

echo "instalando jasper..."
cd "$PARENTPATH/paralelo/bibliotecas/jasper-1.900.1"
./configure --prefix=/usr/local/grib2
make && make install

echo "instalando netcdf..."
cd "$PARENTPATH/paralelo/bibliotecas/netcdf-4.1.3"
./configure --prefix=/usr/local/netcdf --disable-dap --disable-netcdf-4 --disable-shared
make && make install

# instalação do modelo
echo "preparando modelo..."

# "WRF" e "WRF-4.0" são as possibilidades esperadas para nome do diretório
# do modelo descompactado
cd "$PARENTPATH/paralelo/WRF" || cd "$PARENTPATH/paralelo/WRF-4.0"

# 34 = opção de paralelismo e compiladores a serem usados
# 1 = opção "simples" de aninhamento do WRF
echo "34 1" | ./configure

echo "compilando modelo. Vai lá pegar um café..."
./compile em_real

######### instalação do WPS ########
echo "preparando wps..."

cd "$PARENTPATH/paralelo/WPS" 

# 3 = opção(Linux x86_64, gfortran(dmpar))

echo "3" | ./configure
sed -i '42s/WRFV3/WRF/g' configure.wps

# compilando WPS
echo "compilando WPS. Aguarde..."
./compile
echo "compilação concluída! :D" 

# alterando caminho dos dados geograficos no namelist do wps
cd "$PARENTPATH/paralelo/WPS"
sed -i '39s+/glade/p/work/wrfhelp/WPS_GEOG+'$PARENTPATH'paralelo/GEOG_files/WPS_GEOG+g' namelist.wps

echo "Se tudo deu certo, aparecerão 3 executaveis do geogrid, metgrid e ungrib no diretorio WPS!"

######### instalação do ARWPost ########

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
echo "Compilação do ARWPost concluída!!!"

