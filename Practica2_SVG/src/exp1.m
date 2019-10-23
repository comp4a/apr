# Cargamos los datos de test y entrenamiento
load data/hart/tr.dat;
load data/hart/trlabels.dat;

# Representación gráfica que nos permite observar 
# que no son linealmente separables
plot(tr(trlabels==1,1),
tr(trlabels==1,2),"x",
tr(trlabels==2,1),
tr(trlabels==2,2),"s");