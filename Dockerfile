# antes de executar o container, siga as instruções de pre-build no README.

# a compilação do modelo apresentou problemas com versões 11 e 10 do GCC.
FROM gcc:8.5.0
LABEL version="0.0.1"
LABEL description="Instalação do modelo WRFv4 pelo Laboratório de Monitoramento \
e Modelagem de Sistemas Climáticos (LaMMoC) da Universidade Federal Fluminense (UFF)"
LABEL maintainers="ericmiguel@id.uff.br, louisefonseca@id.uff.br, rodrigocaldas@id.uff.br"

COPY paralelo /paralelo
COPY scripts /scripts

RUN apt-get update
# necessário para a compilação do modelo
RUN apt-get install csh
# opcional, porém útil para inspeção em modo interativo
RUN apt-get install nano

# configuração das variáveis de ambiente
ENV CC /usr/local/bin/gcc
ENV CXX /usr/local/bin/g++
ENV FC /usr/local/bin/gfortran
ENV F77 /usr/local/bin/gfortran
ENV SFC /usr/local/bin/gfortran
ENV FCGLAGS -m64
ENV FFLAGS -m64
ENV JASPERLIB /usr/local/grib2/lib
ENV JASPERINC /usr/local/grib2/include
ENV LDFLAGS -L/usr/local/grib2/lib
ENV CPPFLAGS -I/usr/local/grib2/include
ENV NETCDF /usr/local/netcdf
ENV NETCDF_classic 1
ENV MPI /usr/local/mpich
ENV LD_LIBRAY_PATH="/usr/local/grib2/lib:$LD_LIBRARY_PATH"
ENV PATH="/opt/opengrads:$MPI/bin:${PATH}"

# instalação das dependências
RUN bash ./scripts/build.sh
