#!/bin/bash
#Script que baixa os arquivos de previsao (resolucao 0.25o) do GFS.

GFS=/paralelo/WRF/GFS


cd $GFS
rm $GFS/gfs.*
rm $GFS/relatorio.*

dia=`date +%d`
ano=`date +%Y`
mes=`date +%m`
HORA=`date +%T`

export RELATORIOGFSFTP=$GFS/relatorio.gfs.0p25.${ano}${mes}${dia}.log
export WGET=/usr/bin/wget

# Baixa os arquivos até 240 horas, de 3 em 3.

echo ""$dia"/"$mes"/"$ano""

    for i in  `seq 0 3 240`; do
        hora=`printf "%03i\n" $i`
        echo $HORA >> $RELATORIOGFSFTP
        echo $hora >> $RELATORIOGFSFTP
        $WGET -a -O "gfs.t00z.pgrb2.0p25.f${hora}" -nc "https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_0p25.pl?file=gfs.t00z.pgrb2.0p25.f${hora}&all_lev=on&all_var=on&subregion=&leftlon=278&rightlon=350&toplat=10&bottomlat=-55&dir=%2Fgfs.${ano}${mes}${dia}%2F00%2Fatmos"
        mv filter_gfs* gfs.t00z.pgrb2.0p25.f${hora}

# Caminho antigo para baixar gfs completo sem recorte
#        $WGET -a -O "gfs.t00z.pgrb2.0p25.f${hora}" -nc "https://ftp.ncep.noaa.gov/data/nccf/com/gfs/prod/gfs.${ano}${mes}${dia}/00/atmos/gfs.t00z.pgrb2.0p25.f${hora}"
    done

Hfinal=`date +%T`
echo "Tempo download" >>$RELATORIOGFSFTP
echo $Hfinal >> $RELATORIOGFSFTP

    cat $RELATORIOGFSFTP | grep ftp | awk {'print $2'} | awk 'NR==1{print $1}' >> $RELATORIOGFSFTP; cat $RELATORIOGFSFTP | grep ftp | awk {'print $2'} | awk 'END {print $1}'>>$RELATORIOGFSFTP
