# Cargamos los datos de test y entrenamiento
load data/hart/tr.dat;          # Muestras entrenamiento
load data/hart/trlabels.dat;    # Etiquetas entrenamiento
load data/hart/ts.dat;          # Muestras test
load data/hart/tslabels.dat     # Etiquetas test

N = rows(tr);

# El tipo de kernel "-t 2" corresponde al tipo "one-class SVM"
# Res es un tipo estructurado que contiene, entre otros:
#   los parámetros del modelo
#   los ı́ndices de los vectores que han resultado ser vectores soporte
#   el multiplicador de Lagrange
res = svmtrain(trlabels, tr, '-t 2 -c 1');

# Representación gráfica de las muestras que nos permite observar 
# que no son linealmente separables
plot(tr(trlabels==1,1),
tr(trlabels==1,2),"x",
tr(trlabels==2,1),
tr(trlabels==2,2),"s");
pause(2);

# Representación gráfica de las muestras junto a los vectores soporte
plot(tr(trlabels==1,1),
     tr(trlabels==1,2),"x",
     tr(trlabels==2,1),
     tr(trlabels==2,2),"s",
     tr(res.sv_indices,1),
     tr(res.sv_indices,2),"dg","markersize",8,"markerfacecolor","g");

# Calculo de la probabilidad empirica de error
# Empleando las etiquetas predichas
predictedLabels = svmpredict(tslabels,ts, res,'');
p = mean(predictedLabels==tslabels);

# Calculo del intervalo de confianza
epsilon = 1.96 * sqrt(p * (1 - p) / N)
intlow = p - epsilon
intup = p + epsilon
printf("El intervalo de confianza es [%f, %f]\n", intlow * 100, intup * 100);