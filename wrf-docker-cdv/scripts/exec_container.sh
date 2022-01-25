#!/bin/bash

docker container start WRF_container
#docker exec -i WRF_container bash < sistema.sh
docker exec -i WRF_container bash < sistemateste2.sh
./gerafigurasteste.sh
