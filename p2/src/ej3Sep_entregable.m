# Cargamos los datos de entrenamiento
load data/mini/trSep.dat;          # Muestras entrenamiento (separable)
load data/mini/trSeplabels.dat     # Etiquetas entrenamiento (separable)

N = rows(tr);

# El tipo de kernel "-t 0" corresponde al tipo lineal
# Res es un tipo estructurado que contiene, entre otros:
#   los parámetros del modelo
#   los ı́ndices de los vectores que han resultado ser vectores soporte
#   el multiplicador de Lagrange
res = svmtrain(trlabels, tr, '-t 0 -c 1');

# Representación gráfica de las muestras que nos permite observar 
# que no son linealmente separables
plot(tr(trlabels==1,1),
tr(trlabels==1,2),"d","markersize",8,"markerfacecolor","b",
tr(trlabels==2,1),
tr(trlabels==2,2),"s","markersize",8,"markerfacecolor","r");
pause(2);

vectores_soporte = res.sv_indices;

# Representación gráfica de las muestras junto a los vectores soporte
plot(tr(trlabels==1,1),
     tr(trlabels==1,2),"d","markersize",8,"markerfacecolor","b",
     tr(trlabels==2,1),
     tr(trlabels==2,2),"s","markersize",8,"markerfacecolor","r",
     tr(vectores_soporte,1),
     tr(vectores_soporte,2),"og","markersize",16);
