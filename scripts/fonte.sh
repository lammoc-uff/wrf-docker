#!/bin/bash

# TODO(ericmiguel): remover redundância dessas variáveis ao longo dos scripts
SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PARENTPATH=`dirname $SCRIPTPATH`


declare -A fontes

fontes["wrf-4.0"]="https://github.com/wrf-model/WRF/archive/refs/tags/v4.0.tar.gz"
fontes["zlib-1.2.7"]="https://github.com/madler/zlib/archive/refs/tags/v1.2.7.tar.gz"
fontes["netcdf-4.1.3"]="https://github.com/Unidata/netcdf-c/archive/refs/tags/netcdf-4.1.3.tar.gz"
fontes["jasper-1.900.1"]="https://github.com/jasper-software/jasper/archive/refs/tags/version-1.900.1.tar.gz"
fontes["libpng-1.2.59"]="https://github.com/glennrp/libpng/archive/refs/tags/v1.2.59.tar.gz"
fontes["mpich-3.0.4"]="https://www.mpich.org/static/downloads/3.0.4/mpich-3.0.4.tar.gz"

for biblioteca in ${!fontes[@]}; do
    echo "baixando $biblioteca ..." 
    wget ${fontes[${biblioteca}]} -O "$PARENTPATH/downloads/$biblioteca.tar.gz"
done
