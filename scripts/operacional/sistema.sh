#!/bin/bash

############### Configuracao manual pelo usuario ##########################
export RODADA=00               #Horario da rodada do GFS
export PREV=10                 #Quantidade de dias de previsao
export NPROC=8                 #Quantidade de nucleos para processamento
export CONJUNTO=1             #reservado para futuros testes para ensemble
export RAIZ=/home/lammoc/wrfoperacional/WRF_paral
export GFS=$RAIZ/GFS/0p25
export MPIRUN=/usr/local/mpich/bin/mpirun
export GRADS=/opt/grads-2.0.2/bin/grads

#%%%%%%%%%%%%%%%%% configura os dias de previsao %%%%%%%%%%%%%%%%%%%%%%%%%%
PREVISAO_DATA=`date --date "$PREV days" +"%Y-%m-%d"`
export DATA=$(date +%Y-%m-%d)-00Z
echo $PREVISAO_DATA
export RUN_HOURS=`expr $PREV \* 24`
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#%%%%%%%%%%%%%%%%% configura os diretorios complementares %%%%%%%%%%%%%%%%%
export SCRIPTS=$RAIZ/scripts
export WRF=$RAIZ/dominio
export WPS=$RAIZ/WPS
export RELATORIOS=$RAIZ/relatorios
export ARWPOST=$RAIZ/ARWpost
export FIGURAS=$RAIZ/figuras
export FIGTEMPORARIO=$RAIZ/figuras/temporario
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#%%%%%%%%%%%%%%%%% configura as datas necessarias %%%%%%%%%%%%%%%%%%%%%%%%%
export ANO_HOJE=$(date +%Y)
export MES_HOJE=$(date +%m)
export DIA_HOJE=$(date +%d)
export ANO_FUTURO=`date --date "$PREV days" +"%Y"`
export MES_FUTURO=`date --date "$PREV days" +"%m"`
export DIA_FUTURO=`date --date "$PREV days" +"%d"`
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#%%%%%%%%%%%%%%%% Baixa arquivos do GFS de 0.25 %%%%%%%%%%%%%%%%%%%%%%%%%%%
#$SCRIPTS/baixa_gfs_0p25.sh

#%%%%%%%%%%%%%%%%%% Prepara relatorio %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo "****************************************************************************
Rodada de $DIA_HOJE / $MES_HOJE / $ANO_HOJE - Previsao para $PREV dias ($RUN_HOURS horas), com $NPROC nucleos." > $RELATORIOS/$DATA.relatorio.geral.txt
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#%%%%%%%%%%%%%%%%% altera as datas dos namelists %%%%%%%%%%%%%%%%%%%%%%%%%%
echo -n "Alterando namelist.wps" >> $RELATORIOS/$DATA.relatorio.geral.txt
cat $SCRIPTS/namelist.wps.base | sed "s/ANO_HOJE/$ANO_HOJE/g ; s/MES_HOJE/$MES_HOJE/g ; s/DIA_HOJE/$DIA_HOJE/g ; s/RODADA/$RODADA/g ; s/ANO_FUTURO/$ANO_FUTURO/g ; s/MES_FUTURO/$MES_FUTURO/g ; s/DIA_FUTURO/$DIA_FUTURO/g " > $WPS/namelist.wps
echo "... ok!"  >> $RELATORIOS/$DATA.relatorio.geral.txt

echo -n "Alterando namelist.input" >> $RELATORIOS/$DATA.relatorio.geral.txt
cat $SCRIPTS/namelist.input.base | sed "s/ANO_HOJE/$ANO_HOJE/g ; s/MES_HOJE/$MES_HOJE/g ; s/DIA_HOJE/$DIA_HOJE/g ; s/RODADA/$RODADA/g ; s/ANO_FUTURO/$ANO_FUTURO/g ; s/MES_FUTURO/$MES_FUTURO/g ; s/DIA_FUTURO/$DIA_FUTURO/g ; s/RUN_HOURS/$RUN_HOURS/g" > $WRF/namelist.input
echo "... ok!"  >> $RELATORIOS/$DATA.relatorio.geral.txt
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#%%%%%%%%%%%%%%%%% Limpa diretorio %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo -n "Limpando diretorio do WRF"   >> $RELATORIOS/$DATA.relatorio.geral.txt
cd $WPS
rm $WPS/GRIBF*
rm $WPS/FILE*
cd $WRF
rm $WRF/PFIL*
rm $WRF/met_em*
rm $WRF/wrfo*
cd $ARWPOST
rm $ARWPOST/*.dat
rm $ARWPOST/*.ctl
echo "... ok!"  >> $RELATORIOS/$DATA.relatorio.geral.txt
##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd $WPS
$WPS/geogrid.exe

##%%%%%%%%%%%%%%%%% UNGRIB %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo -n "Link_grib"  >> $RELATORIOS/$DATA.relatorio.geral.txt
cd $WPS
$WPS/link_grib.csh $GFS/gfs.t"$RODADA"z.p*
echo "... ok!" >> $RELATORIOS/$DATA.relatorio.geral.txt


echo -n "Ungrib.exe : " >> $RELATORIOS/$DATA.relatorio.geral.txt
cd $WPS
UNGRIB_I=$(date +"%Y-%m-%d-%T")
echo -n "iniciou em $UNGRIB_I" >> $RELATORIOS/$DATA.relatorio.geral.txt
$WPS/ungrib.exe > $RELATORIOS/$DATA.relatorio.ungrib
UNGRIB_F=$(date +"%Y-%m-%d-%T")
echo -n " e finalizou em $UNGRIB_F" >> $RELATORIOS/$DATA.relatorio.geral.txt
sleep 2
TESTE_UNGRIB=`cat $WPS/ungrib.log | grep "Successful" | awk {'print $5,$6,$7,$8,$9'}`
  if [ "$TESTE_UNGRIB" == "Successful completion of program ungrib.exe" ]; then
     echo " ... com sucesso!" >> $RELATORIOS/$DATA.relatorio.geral.txt
  else
     echo " ... ATENCAO: nao foi executado" >> $RELATORIOS/$DATA.relatorio.geral.txt
  fi
##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#
##%%%%%%%%%%%%%%%%% METGRID %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
echo -n "Metgrid.exe: " >> $RELATORIOS/$DATA.relatorio.geral.txt
cd $WPS
METGRID_I=$(date +"%Y-%m-%d-%T")
echo -n "iniciou em $METGRID_I" >> $RELATORIOS/$DATA.relatorio.geral.txt
$WPS/metgrid.exe > $RELATORIOS/$DATA.relatorio.metgrid
METGRID_F=$(date +"%Y-%m-%d-%T")
echo -n " e finalizou em $METGRID_F" >> $RELATORIOS/$DATA.relatorio.geral.txt
sleep 2
TESTE_METGRID=`cat $WPS/metgrid.log | grep "Successful" | awk {'print $5,$6,$7,$8,$9'}`
  if [ "$TESTE_METGRID" == "Successful completion of program metgrid.exe" ]; then
     echo " ... com sucesso!" >> $RELATORIOS/$DATA.relatorio.geral.txt
  else
     echo " ... ATENCAO: nao foi executado" >> $RELATORIOS/$DATA.relatorio.geral.txt
  fi
##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#for conjunto in 'seq 1 $CONJUNTOS'; do

    #COlocar aqui a alteracao do namelist.input
    #criar um namelist.input para cada conjunto

#%%%%%%%%%%%%%%%%% REAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
REAL_I=$(date +"%Y-%m-%d-%T")
rm $RELATORIOS/$DATA.relatorio.real
echo -n "Real.exe   : " >> $RELATORIOS/$DATA.relatorio.geral.txt
cd $WRF
echo -n "iniciou em $REAL_I" >> $RELATORIOS/$DATA.relatorio.geral.txt
$WRF/real.exe
REAL_F=$(date +"%Y-%m-%d-%T")
cp $WRF/rsl.out.0000 $RELATORIOS/$DATA.relatorio.real
echo -n " e finalizou em $REAL_F" >> $RELATORIOS/$DATA.relatorio.geral.txt
sleep 2
TESTE_REAL=`cat $RELATORIOS/$DATA.relatorio.real | grep "SUCCESS" | awk {'print $3,$4,$5,$6,$7'}`
  if [ "$TESTE_REAL" == "real_em: SUCCESS COMPLETE REAL_EM INIT" ]; then
     echo " ... com sucesso!" >> $RELATORIOS/$DATA.relatorio.geral.txt
  else
     echo " ... ATENCAO: nao foi executado" >> $RELATORIOS/$DATA.relatorio.geral.txt
  fi
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#%%%%%%%%%%%%%%%%% WRF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ulimit -s unlimited
WRF_I=$(date +"%Y-%m-%d-%T")
rm $RELATORIOS/$DATA.relatorio.real
echo -n "WRF.exe    : " >> $RELATORIOS/$DATA.relatorio.geral.txt
cd $WRF
rm -rf $WRF/rsl.*
echo -n "iniciou em $WRF_I" >> $RELATORIOS/$DATA.relatorio.geral.txt
$MPIRUN -np $NPROC $WRF/wrf.exe
WRF_F=$(date +"%Y-%m-%d-%T")
cp $WRF/rsl.out.0000 $RELATORIOS/$DATA.relatorio.wrf
echo -n " e finalizou em $WRF_F" >> $RELATORIOS/$DATA.relatorio.geral.txt
sleep 2
TESTE_WRF=`cat $RELATORIOS/$DATA.relatorio.wrf | grep "SUCCESS" | awk {'print $3, $4, $5, $6'}`
  if [ "$TESTE_WRF" == "wrf: SUCCESS COMPLETE WRF" ]; then
     echo " ... com sucesso!" >> $RELATORIOS/$DATA.relatorio.geral.txt
  else
     echo " ... ATENCAO: nao foi executado" >> $RELATORIOS/$DATA.relatorio.geral.txt
  fi
##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#
##%%%%%%%%%%%%%%%% Gera arquivos ctl e dat para o Grads %%%%%%%%%%%%%%%%%%%%
#
##### d03 ######
echo -n "Alterando namelist.ARWpost d03"  >> $RELATORIOS/$DATA.relatorio.geral.txt
cat $SCRIPTS/namelist.ARWpost_d03.base | sed "s/ANO_HOJE/$ANO_HOJE/g ; s/MES_HOJE/$MES_HOJE/g ; s/DIA_HOJE/$DIA_HOJE/g ; s/RODADA/$RODADA/g ; s/ANO_FUTURO/$ANO_FUTURO/g ; s/MES_FUTURO/$MES_FUTURO/g ; s/DIA_FUTURO/$DIA_FUTURO/g " > $ARWPOST/namelist.ARWpost
echo "... ok!"  >> $RELATORIOS/$DATA.relatorio.geral.txt
ulimit -s unlimited
ARWPOST_I=$(date +"%Y-%m-%d-%T")
echo -n "ARWpost.exe    : " >> $RELATORIOS/$DATA.relatorio.geral.txt
cd $ARWPOST
echo -n "iniciou em $ARWPOST_I" >> $RELATORIOS/$DATA.relatorio.geral.txt
$ARWPOST/ARWpost.exe  > $RELATORIOS/$DATA.relatorio.arwpost
ARWPOST_F=$(date +"%Y-%m-%d-%T")
echo -n " e finalizou em $ARWPOST_F" >> $RELATORIOS/$DATA.relatorio.geral.txt
sleep 2
TESTE_ARWPOST=`cat $RELATORIOS/$DATA.relatorio.arwpost | grep "Successful" | awk {'print $2, $3, $4, $5'}`
  if [ "$TESTE_ARWPOST" == "Successful completion of ARWpost" ]; then
     echo " ... com sucesso!" >> $RELATORIOS/$DATA.relatorio.geral.txt
  else
     echo " ... ATENCAO: nao foi executado" >> $RELATORIOS/$DATA.relatorio.geral.txt
  fi

#### d02 ######
echo -n "Alterando namelist.ARWpost d02"  >> $RELATORIOS/$DATA.relatorio.geral.txt
cat $SCRIPTS/namelist.ARWpost_d02.base | sed "s/ANO_HOJE/$ANO_HOJE/g ; s/MES_HOJE/$MES_HOJE/g ; s/DIA_HOJE/$DIA_HOJE/g ; s/RODADA/$RODADA/g ; s/ANO_FUTURO/$ANO_FUTURO/g ; s/MES_FUTURO/$MES_FUTURO/g ; s/DIA_FUTURO/$DIA_FUTURO/g " > $ARWPOST/namelist.ARWpost
echo "... ok!"  >> $RELATORIOS/$DATA.relatorio.geral.txt
ulimit -s unlimited
ARWPOST_I=$(date +"%Y-%m-%d-%T")
echo -n "ARWpost.exe    : " >> $RELATORIOS/$DATA.relatorio.geral.txt
cd $ARWPOST
echo -n "iniciou em $ARWPOST_I" >> $RELATORIOS/$DATA.relatorio.geral.txt
$ARWPOST/ARWpost.exe  > $RELATORIOS/$DATA.relatorio.arwpost
ARWPOST_F=$(date +"%Y-%m-%d-%T")
echo -n " e finalizou em $ARWPOST_F" >> $RELATORIOS/$DATA.relatorio.geral.txt
sleep 2
TESTE_ARWPOST=`cat $RELATORIOS/$DATA.relatorio.arwpost | grep "Successful" | awk {'print $2, $3, $4, $5'}`
  if [ "$TESTE_ARWPOST" == "Successful completion of ARWpost" ]; then
     echo " ... com sucesso!" >> $RELATORIOS/$DATA.relatorio.geral.txt
  else
     echo " ... ATENCAO: nao foi executado" >> $RELATORIOS/$DATA.relatorio.geral.txt
  fi

#### d01 ######
echo -n "Alterando namelist.ARWpost d01"  >> $RELATORIOS/$DATA.relatorio.geral.txt
cat $SCRIPTS/namelist.ARWpost_d01.base | sed "s/ANO_HOJE/$ANO_HOJE/g ; s/MES_HOJE/$MES_HOJE/g ; s/DIA_HOJE/$DIA_HOJE/g ; s/RODADA/$RODADA/g ; s/ANO_FUTURO/$ANO_FUTURO/g ; s/MES_FUTURO/$MES_FUTURO/g ; s/DIA_FUTURO/$DIA_FUTURO/g " > $ARWPOST/namelist.ARWpost
echo "... ok!"  >> $RELATORIOS/$DATA.relatorio.geral.txt
ulimit -s unlimited
ARWPOST_I=$(date +"%Y-%m-%d-%T")
echo -n "ARWpost.exe    : " >> $RELATORIOS/$DATA.relatorio.geral.txt
cd $ARWPOST
echo -n "iniciou em $ARWPOST_I" >> $RELATORIOS/$DATA.relatorio.geral.txt
$ARWPOST/ARWpost.exe  > $RELATORIOS/$DATA.relatorio.arwpost
ARWPOST_F=$(date +"%Y-%m-%d-%T")
echo -n " e finalizou em $ARWPOST_F" >> $RELATORIOS/$DATA.relatorio.geral.txt
sleep 2
TESTE_ARWPOST=`cat $RELATORIOS/$DATA.relatorio.arwpost | grep "Successful" | awk {'print $2, $3, $4, $5'}`
  if [ "$TESTE_ARWPOST" == "Successful completion of ARWpost" ]; then
     echo " ... com sucesso!" >> $RELATORIOS/$DATA.relatorio.geral.txt
  else
     echo " ... ATENCAO: nao foi executado" >> $RELATORIOS/$DATA.relatorio.geral.txt
  fi

########## Gerando figuras ############################
#####ajuste de nome dos arquivos para o site
export DATA_HOJE=$(date --date "0 days" +"%Y%m%d")
export DATA_2=$(date --date "1 days" +"%Y%m%d")
export DATA_3=$(date --date "2 days" +"%Y%m%d")
export DATA_4=$(date --date "3 days" +"%Y%m%d")

cd $SCRIPTS
echo -n " Gerando figuras para d03" >> $RELATORIOS/$DATA.relatorio.geral.txt
cd $SCRIPTS
$SCRIPTS/figuras_d03.sh
$GRADS -lbcx "figuras_d03.gs"
echo "... ok!"  >> $RELATORIOS/$DATA.relatorio.geral.txt

cd $SCRIPTS
echo -n " Gerando figuras para d02" >> $RELATORIOS/$DATA.relatorio.geral.txt
$SCRIPTS/figuras_d02.sh
$GRADS -lbcx "figuras_d02.gs"
echo "... ok!"  >> $RELATORIOS/$DATA.relatorio.geral.txt

cd $SCRIPTS
echo -n " Gerando figuras para d01" >> $RELATORIOS/$DATA.relatorio.geral.txt
$SCRIPTS/figuras_d01.sh
$GRADS -lbcx "figuras_d01.gs"
echo "... ok!"  >> $RELATORIOS/$DATA.relatorio.geral.txt

############## Criando Meteogramas para DCNit ############################

cd $SCRIPTS
echo -n " Gerando Meteogramas" >> $RELATORIOS/$DATA.relatorio.geral.txt
$SCRIPTS/meteograma1.sh
$GRADS -pbcx "meteograma1.gs"
$SCRIPTS/meteograma2.sh
$GRADS -pbcx "meteograma2.gs"
$SCRIPTS/meteograma3.sh
$GRADS -pbcx "meteograma3.gs"

echo "... ok!"  >> $RELATORIOS/$DATA.relatorio.geral.txt

################# Defesa Civil de Niteroi ##################
# Coloca o logo da Defesa Civil de Niteroi na figura

cd $SCRIPTS
$SCRIPTS/put_logo_dcnit.sh

# Envia figuras para a DC Niteroi COM marca d'agua da Defesa Civil
cd $SCRIPTS
$SCRIPTS/put_wrf_operacional_dcnit.sh

################ Criando arquivos ascii de saida ###################
#cd $SCRIPTS
#echo -n " Gerando arquivos ascii" >> $RELATORIOS/$DATA.relatorio.geral.txt
#$SCRIPTS/dados_ascii.sh
#$GRADS -lbcx "dados_ascii.gs"
#mv prec202* temp202* vent202* dados_ascii
#echo "... ok!"  >> $RELATORIOS/$DATA.relatorio.geral.txt

################ Fazendo Backup das Figuras  ###################
#cd $SCRIPTS
#echo -n " Fazendo Backup das Figuras" >> $RELATORIOS/$DATA.relatorio.geral.txt
#$SCRIPTS/backup_figuras.sh

#echo "... ok!"  >> $RELATORIOS/$DATA.relatorio.geral.txt


#### AMBMET ####
#AMBMET_SCRIPTS=/home/lammoc/wrf_operacional/operacional/ambmet/scripts
#cd $AMBMET_SCRIPTS
#$AMBMET_SCRIPTS/ambmet.sh

# Envia as figuras para o site da Ambmet SEM a marca d'agua
#$SCRIPTS/put_wrf_operacional.sh

