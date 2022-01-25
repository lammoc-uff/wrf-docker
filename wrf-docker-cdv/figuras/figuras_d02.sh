#!/bin/bash


echo "
'open $ARWPOST/"$ANO_HOJE"-"$MES_HOJE"-"$DIA_HOJE"_"$RODADA":00:00_d02.ctl'
'set display color white'

'set mpdset hires brmap'

t=1
*Cria variaveis com as informacoes dos valores maximos de tempo, lat e lon.
    'q file'
    line=sublin(result,5)
    tmax=subwrd(line,12)
    xmax=subwrd(line,3)
    ymax=subwrd(line,6)


while t <=tmax

*hora=t-1

  'set t 't
   data=subwrd(result,4)
   aa=substr(data,1,4)
   teste=substr(data,7,1)
   if (teste = ':')
      mm=substr(data,6,1)
      teste=substr(data,9,1)
      if (teste = ':')
         dd=substr(data,8,1)
         teste=substr(data,11,1)
         if (teste = ' ')
            hh=substr(data,10,1)
         else
            hh=substr(data,10,2)
         endif
      else
         dd=substr(data,8,2)
         teste=substr(data,12,1)
         if (teste = ' ')
            hh=substr(data,11,1)
         else
            hh=substr(data,11,2)
         endif

      endif

   else
mm=substr(data,6,2)
      teste=substr(data,10,1)
      if (teste = ':')
         dd=substr(data,9,1)
         teste=substr(data,12,1)
         if (teste = ' ')
            hh=substr(data,11,1)
         else
            hh=substr(data,11,2)
         endif
       else
         dd=substr(data,9,2)
         teste=substr(data,13,1)
         if (teste = ' ')
            hh=substr(data,12,1)
         else
            hh=substr(data,12,2)
         endif

      endif

   endif


if (mm < 10 )
   mes='0'mm
   else
   mes=mm
endif
if (dd < 10 )
   dia='0'dd
   else
   dia=dd
endif

if (hh = 0 | hh = 1 | hh = 2)
   if dia = 01
       if mes = 01
          dia = 31
          mes = 12       
          aa=aa-1
       endif
       if mes = 02
          dia = 31
          mes = 01
       endif
       if mes = 03
          dia = 28
          mes = 02
       endif
       if mes = 04
          dia = 31
          mes = 03
       endif
       if mes = 05
          dia = 30
          mes = 04
       endif
       if mes = 06
          dia = 31
          mes = 05
       endif
       if mes = 07
          dia = 30
          mes = 06
       endif 
       if mes = 08
          dia = 31
          mes = 07
       endif
       if mes = 09
          dia = 31
          mes = 08
       endif
       if mes = 10
          dia = 30
          mes = 09
       endif
       if mes = 11
          dia = 31
          mes = 10
       endif
       if mes = 12
          dia = 30
          mes = 11
       endif  
    else
       dia = dia - 1  
         if dia < 10
            dia='0'dia
            else
            dia=dia
         endif
       horalocal = hh -3
   endif

   if hh = 0
     horalocal = 21
   endif
   if hh = 1
     horalocal = 22
   endif
   if hh = 2
     horalocal = 23
   endif
 
else
  horalocal = hh - 3
     if horalocal < 10
       horalocal='0'horalocal
       else
       horalocal=horalocal
     endif

endif

if (t < 9)
   diaprev=1
   horaprev=t-1
endif
if (t>8)&(t<17)
   diaprev=2
   horaprev=t-9
endif
if (t>16)&(t<25)
   diaprev=3
   horaprev=t-17
endif
if (t>24)&(t<33)
   diaprev=4
   horaprev=t-25
endif
if (t>32)&(t<41)
   diaprev=5
   horaprev=t-33
endif
if (t>40)&(t<49)
   diaprev=6
   horaprev=t-41
endif
if (t>48)&(t<57)
   diaprev=7
   horaprev=t-49
endif
if (t>56)&(t<65)
   diaprev=8
   horaprev=t-57
endif
if (t>64)&(t<73)
   diaprev=9
   horaprev=t-65
endif
if (t>72)&(t<81)
   diaprev=10
   horaprev=t-73
endif
if (t>80)&(t<89)
   diaprev=11
   horaprev=t-81
endif


'c'
'set cint 1'
'set gxout grfill'
'run rgb.gs'

say VENTO_10m
'set z 1'
'set rgb 29 165   0   0'
'set rgb 99 255 255 255'
'set rgb 29 165   0   0'
'set clevs 0 2 4 5 6 7 8 9 10 11 12 13 14 15 16 17 20'
'set ccols 48 47 46 45 44 43 42 5 13 10 21 22 23 24 26 27 28 29'
*'set clevs 0 1 2 4 6 8 10 12 14 16 18 20 22 24'
*'set ccols 0 0 51 53 55 57 58 60 62 63 64 65 66 68'
*'set clevs 0 2 4 5 6 7 8 9 10 11 12 13 14 15 16 17 20'
*'set ccols 48 47 46 45 44 43 42 5 13 10 21 22 23 24 26 27 28'
'set grads off'
'd mag(u10m,v10m)'
'set arrscl 0.5 20'
'set gxout vector'
'd skip(u10m,5,5);v10m'
'draw map'
'xcbar 10.0 10.2 1.0 7.0 -line on -edge circle'
'set string 1'
'set strsiz 0.2'
'draw string 2.7 8.3 WRF - Vento em Superficie (m/s)'
'set strsiz 0.12'
'draw string 2.2 7.94 Rodada: "$DIA_HOJE"/"$MES_HOJE"/"$ANO_HOJE" "$RODADA"GMT'
'draw string 5.2 7.94 Previsao: 'dia'/'mes'/'aa' 'horalocal' h (Brasilia)'
'printim $FIGURAS/uv1000_1_2_'diaprev'_'hh'Z.gif'

'c'
say VENTO_850
'set lev 850'
'set rgb 99 255 255 255'
'set rgb 29 165   0   0'
'set clevs 4 5 6 7 8 9 10 11 12 13 14 15 16 17 20 25 30'
'set ccols 48 47 46 45 44 43 42 5 13 10 21 22 23 24 26 27 28 29'
'set grads off'
* 'd mag(u,v)'
* 'set arrscl 0.5 20'
* 'set gxout vector'
* 'd skip(u,5,5);v'
'set gxout stream'
'd u;v;mag(u,v)'
'draw map'
'xcbar 10.0 10.2 1.0 7.0 -line on -edge circle'
'set string 1'
'set strsiz 0.2'
'draw string 2.7 8.3 WRF - Escoamento em 850 hPa (m/s)'
'set strsiz 0.12'
'draw string 2.2 7.94 Rodada: "$DIA_HOJE"/"$MES_HOJE"/"$ANO_HOJE" "$RODADA"GMT'
'draw string 5.2 7.94 Previsao: 'dia'/'mes'/'aa' 'horalocal' h (Brasilia)'
'printim $FIGURAS/uv850_1_2_'diaprev'_'hh'Z.gif'

'c'
say VENTO_700
'set lev 700'
'set rgb 99 255 255 255'
'set rgb 29 165   0   0'
 'set clevs 5 6 7 8 9 10 11 12 13 14 15 16 17 20 25 30 40'
 'set ccols 48 47 46 45 44 43 42 5 13 10 21 22 23 24 26 27 28 29'
'set grads off'
'set gxout stream'
'd u;v;mag(u,v)'
'draw map'
'xcbar 10.0 10.2 1.0 7.0 -line on -edge circle'
'set string 1'
'set strsiz 0.2'
'draw string 2.7 8.3 WRF - Escoamento em 700 hPa (m/s)'
'set strsiz 0.12'
'draw string 2.2 7.94 Rodada: "$DIA_HOJE"/"$MES_HOJE"/"$ANO_HOJE" "$RODADA"GMT'
'draw string 5.2 7.94 Previsao: 'dia'/'mes'/'aa' 'horalocal' h (Brasilia)'
'printim $FIGURAS/uv700_1_2_'diaprev'_'hh'Z.gif'

'c'
say VENTO_200
'set lev 200'
*'set clevs 0 1 2 4 6 8 10 12 14 16 18 20 22 24'
*'set ccols 0 0 51 53 55 57 58 60 62 63 64 65 66 68'
'set clevs 10 11 12 13 14 15 16 17 20 22 24 26 28 30 35 40 50'
'set ccols 48 47 46 45 44 43 42 5 13 10 21 22 23 24 26 27 28'
'set grads off'
'set lev 200'
'set gxout stream'
'd u;v;mag(u,v)'
'draw map'
'xcbar 10.0 10.2 1.0 7.0 -line on -edge circle'
'set string 1'
'set strsiz 0.2'
'draw string 2.7 8.3 WRF - Escoamento em 200 hPa (m/s)'
'set strsiz 0.12'
'draw string 2.2 7.94 Rodada: "$DIA_HOJE"/"$MES_HOJE"/"$ANO_HOJE" "$RODADA"GMT'
'draw string 5.2 7.94 Previsao: 'dia'/'mes'/'aa' 'horalocal' h (Brasilia)'
'printim $FIGURAS/uv200_1_2_'diaprev'_'hh'Z.gif'

*'c'
*   say TSM
*   'set z 1'
*   'set mpdset hires brmap'
*   'set gxout shaded'
*   'define mascara=landmask*(-1)'
*   'define tsm=sst-273'
*   'd maskout(tsm,mascara)'
*   'xcbar -line on -edge circle'
*   'draw map'
*   'set string 1'
*   'set strsiz 0.2'
*   'draw string 2.7 8.3 WRF - Temperatura da superficie do mar (oC)'
*   'set strsiz 0.12'
*   'draw string 2.7 7.94 Rodada: "$DIA_HOJE"/"$MES_HOJE"/"$ANO_HOJE" "$RODADA"GMT'
*   'draw string 5.6 7.94 Previsao: 'dia'/'mes'/'aa' 'horalocal' h (Brasilia)'
*   'printim $FIGURAS/tsm_1_2_'diaprev'_'horaprev'Z.gif'

'c'
   say SLP
   'set z 1'
   'set mpdset hires brmap'
*   'set gxout shaded'
   'set rgb 61 176 196 222'
   'set rgb 62 173 216 230'
   'set rgb 63 72 209 204'
   'set clevs 1000 1004 1006 1010 1012 1014 1016 1017 1018 1019 1020 1021 1022 1023 1024 1025 1026 1028'
    'set ccols 48 46 45 42 61 62 5 11 63 13 3 10 21 22 23 24 26 27 28'
*   'set cint 2'
   'set grads off'
*   'd slp'
   'set cint 1'
   'set gxout contour'
   'd slp'
*   'xcbar 10.0 10.2 1.0 7.0 -line on -edge circle'
   'draw map'
   'set string 1'
   'set strsiz 0.2'
   'draw string 1.3 8.3 WRF - Pressao reduzida ao nivel medio do mar (hPa)'
   'set strsiz 0.12'
   'draw string 2.2 7.94 Rodada: "$DIA_HOJE"/"$MES_HOJE"/"$ANO_HOJE" "$RODADA"GMT'
   'draw string 5.2 7.94 Previsao: 'dia'/'mes'/'aa' 'horalocal' h (Brasilia)'
   'printim $FIGURAS/parnm_1_2_'diaprev'_'hh'Z.gif'

'c'
   say TEMP
   'set z 1'
   'set mpdset hires brmap'
*  light blue to dark blue
'set rgb 41 225 255 255'
'set rgb 42 180 240 250'
'set rgb 43 150 210 250'
'set rgb 44 120 185 250'
'set rgb 45  80 165 245'
'set rgb 46  60 150 245'
'set rgb 47  40 130 240'
'set rgb 48  30 110 235'
'set rgb 49  20 100 210'
*light yellow to dark red
'set rgb 21 255 250 170'
'set rgb 22 255 232 120'
'set rgb 23 255 192  60'
'set rgb 24 255 160   0'
'set rgb 25 255  96   0'
'set rgb 26 255  50   0'
'set rgb 27 225  20   0'
'set rgb 28 192   0   0'
'set rgb 29 165   0   0'
'set rgb 99 255 255 255'
'set clevs 0 5 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40'
'set ccols 0 48 47 46 45 44 43 42 5 13 3 10 21 22 23 24 26 27 28 14'
   'set grads off'
   'set gxout shaded'
   'd t2-273'
   'xcbar 10.0 10.2 1.0 7.0 -line on -edge circle'
   'draw map'
   'set string 1'
   'set strsiz 0.2'
   'draw string 2.7 8.3 WRF - Temperatura a 2 m (oC)'
   'set strsiz 0.12'
   'draw string 2.2 7.94 Rodada: "$DIA_HOJE"/"$MES_HOJE"/"$ANO_HOJE" "$RODADA"GMT'
   'draw string 5.2 7.94 Previsao: 'dia'/'mes'/'aa' 'horalocal' h (Brasilia)'
   'printim $FIGURAS/t2m_1_2_'diaprev'_'hh'Z.gif'

'c'
   say CHUVA
   'set z 1'
   'set mpdset hires brmap'
   'set clevs 0 1 2 3 4 5 6 9 10 15 20 25 30 35 40 45 50'
   'set ccols 0 0 47 45  43 42 5 13 3 10 21 22 23 24 26 27 28 29'
'set gxout shaded'
'set datawarn off'
*'set clevs 1 3 5 10 15 20 25 30 40 50 60 80 100'
*'set ccols 0 9 14 4 11 5 13 3 10 7 12 8 2 6'
   'set grads off'   
   'define chu=rainc(t='t')-rainc(t='t-1')'
   'define va=rainnc(t='t')-rainnc(t='t-1')' 
   'd chu+va'
   'xcbar 10.0 10.2 1.0 7.0 -line on -edge circle'
   'draw map'
   'set string 1'
   'set strsiz 0.2'
   'draw string 2.0 8.3 WRF - Precipitacao acumulada em 1h (mm)'
   'set strsiz 0.12'
   'draw string 2.2 7.94 Rodada: "$DIA_HOJE"/"$MES_HOJE"/"$ANO_HOJE" "$RODADA"GMT'
   'draw string 5.2 7.94 Previsao: 'dia'/'mes'/'aa' 'horalocal' h (Brasilia)'
   'printim $FIGURAS/prec_1_2_'diaprev'_'hh'Z.gif'

'c'
   say U1000
   'set z 1'
   'set mpdset hires brmap'
*   'set clevs 0 10 40 60 75 82 84 86 88 91 93 95 98'
*   'set ccols 102 103 104 105 106 107 108 109 110 111 112'
* yellow to black red
'set rgb 31 255 255 80'
'set rgb 32 255 210 99'
'set rgb 33 255 180 99'
'set rgb 34 255 150 75'
'set rgb 35 255 110 60'
'set rgb 36 255  80 30'
'set rgb 37 255  20  0'
'set rgb 38 255  10  0'
'set rgb 39 200   0  0'
'set rgb 40 180   0  0'
'set rgb 41 124   0  0'
* dark blue to light blue
'set rgb 16   0   0 122'
'set rgb 17   0   0 200'
'set rgb 18   0  10 255'
'set rgb 19   0  91 255'
'set rgb 20 100 150 255'
'set rgb 21 162 189 255'
'set clevs 0 10 20 30 40 50 80 90 95 100'
   'set ccols 0 40 39 37 35 33 0 19 18 17 16'
   'set grads off'
   'set gxout shaded'
   'set z 1'
   'd rh2'
   'xcbar 10.0 10.2 1.0 7.0 -line on -edge circle'
   'draw map'
   'set string 1'
   'set strsiz 0.2'
   'draw string 2.7 8.3 WRF - Umidade relativa do ar (%)'
   'set strsiz 0.12'
   'draw string 2.2 7.94 Rodada: "$DIA_HOJE"/"$MES_HOJE"/"$ANO_HOJE" "$RODADA"GMT'
   'draw string 5.2 7.94 Previsao: 'dia'/'mes'/'aa' 'horalocal' h (Brasilia)'
   'printim $FIGURAS/U1000_1_2_'diaprev'_'hh'Z.gif'

'c'
   say U850
   'set z 1'
   'set mpdset hires brmap'
* yellow to black red
'set rgb 31 255 255 80'
'set rgb 32 255 210 99'
'set rgb 33 255 180 99'
'set rgb 34 255 150 75'
'set rgb 35 255 110 60'
'set rgb 36 255  80 30'
'set rgb 37 255  20  0'
'set rgb 38 255  10  0'
'set rgb 39 200   0  0'
'set rgb 40 180   0  0'
'set rgb 41 124   0  0'
* dark blue to light blue
'set rgb 16   0   0 122'
'set rgb 17   0   0 200'
'set rgb 18   0  10 255'
'set rgb 19   0  91 255'
'set rgb 20 100 150 255'
'set rgb 21 162 189 255'
   'set clevs 0 10 20 30 40 50 80 90 95 100'
   'set ccols 0 40 39 37 35 33 0 19 18 17 16'
   'set grads off'
   'set gxout shaded'
   'set lev 850'
   'd rh'
   'xcbar 10.0 10.2 1.0 7.0 -line on -edge circle'
   'draw map'
   'set string 1'
   'set strsiz 0.2'
   'draw string 1.9 8.3 WRF - Umidade relativa do ar em 850 hPa (%)'
   'set strsiz 0.12'
   'draw string 2.2 7.94 Rodada: "$DIA_HOJE"/"$MES_HOJE"/"$ANO_HOJE" "$RODADA"GMT'
   'draw string 5.2 7.94 Previsao: 'dia'/'mes'/'aa' 'horalocal' h (Brasilia)'
   'printim $FIGURAS/U850_1_2_'diaprev'_'hh'Z.gif'


t=t+1
endwhile
" > $SCRIPTS/figuras_d02.gs

