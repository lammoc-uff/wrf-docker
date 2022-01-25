#!/bin/bash

############### Configuracao manual pelo usuario ##########################
export RODADA=00               #Horario da rodada do GFS
export PREV=10                 #Quantidade de dias de previsao
export NPROC=4                 #Quantidade de nucleos para processamento
export CONJUNTO=1             #reservado para futuros testes para ensemble
export RAIZ=/home/lammoc
#export GFS=$RAIZ/WRF/GFS
#export MPIRUN=/usr/local/mpich/bin/mpirun
export GRADS=grads
export VOLUME=$RAIZ/docker/volumes/namelist_volume/operacional
#%%%%%%%%%%%%%%%%% configura as datas necessarias %%%%%%%%%%%%%%%%%%%%%%%%%
ano=`grep "start_year" $VOLUME/namelist.input | awk '{ print $3 }'`
ANO_HOJE=`echo $ano | cut -d',' -f1`
mes=`grep "start_month" $VOLUME/namelist.input | awk '{ print $3 }'`
MES_HOJE=`echo $mes | cut -d',' -f1`
dia=`grep "start_day" $VOLUME/namelist.input | awk '{ print $3 }'`
DIA_HOJE=`echo $dia | cut -d',' -f1`

export ANO_HOJE=$ANO_HOJE
export MES_HOJE=$MES_HOJE
export DIA_HOJE=$DIA_HOJE

anofut=`grep "end_year" $VOLUME/namelist.input | awk '{ print $3 }'`
ANO_FUTURO=`echo $anofut | cut -d',' -f1`
mesfut=`grep "end_month" $VOLUME/namelist.input | awk '{ print $3 }'`
MES_FUTURO=`echo $mesfut | cut -d',' -f1`
diafut=`grep "end_day" $VOLUME/namelist.input | awk '{ print $3 }'`
DIA_FUTURO=`echo $diafut | cut -d',' -f1`

export ANO_FUTURO=$ANO_FUTURO
export MES_FUTURO=$MES_FUTURO
export DIA_FUTURO=$DIA_FUTURO

#%%%%%%%%%%%%%%%%% configura os dias de previsao %%%%%%%%%%%%%%%%%%%%%%%%%%
#PREVISAO_DATA=`date --date "$PREV days" +"%Y-%m-%d"`
#export DATA=$(date +%Y-%m-%d)-00Z
#echo $PREVISAO_DATA
export RUN_HOURS=`expr $PREV \* 24`
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#%%%%%%%%%%%%%%%%% configura os diretorios complementares %%%%%%%%%%%%%%%%%
export SCRIPTS=$RAIZ/figuras
#export WRF=$RAIZ/WRF
#export WPS=$RAIZ/WPS
export RELATORIOS=$RAIZ/docker/volumes/relatorio_volume
export ARWPOST=$RAIZ/docker/volumes/WRF_out_volume
export FIGURAS=$RAIZ/figuras/conjunto1
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

########## Gerando figuras ############################
#####ajuste de nome dos arquivos para o site
#export DATA_HOJE=$(date --date "0 days" +"%Y%m%d")
#export DATA_2=$(date --date "1 days" +"%Y%m%d")
#export DATA_3=$(date --date "2 days" +"%Y%m%d")
#export DATA_4=$(date --date "3 days" +"%Y%m%d")

cd $SCRIPTS
#echo -n " Gerando figuras para d02" >> $RELATORIOS/$DATA.relatorio.geral.txt
$SCRIPTS/figuras_d02.sh
$GRADS -lbcx "figuras_d02.gs"
#echo "... ok!"  >> $RELATORIOS/$DATA.relatorio.geral.txt

cd $SCRIPTS
#echo -n " Gerando figuras para d01" >> $RELATORIOS/$DATA.relatorio.geral.txt
$SCRIPTS/figuras_d01.sh
$GRADS -lbcx "figuras_d01.gs"
#echo "... ok!"  >> $RELATORIOS/$DATA.relatorio.geral.txt


