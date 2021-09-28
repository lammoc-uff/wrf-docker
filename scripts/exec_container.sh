#!/bin/bash

sudo docker container start WRF_container
sudo docker exec -i WRF_container bash < sistema.sh
sudo docker exec -i WRF_container bash < sistema2.sh
