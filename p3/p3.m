# Cargado de datos del Corpus Hart
load data/hart/tr.dat;
load data/hart/trlabels.dat;
load data/hart/ts.dat;
load data/hart/tslabels.dat;

# Trasponemos los datos para adaptalos a la biblioteca
# nnet trabaja con los datos por columnas, no por filas
mInput = tr’;
mOutput = trlabels’;
mTestInput = ts’;
mTestOutput = tslabels’;

# La proporcion en el uso de las muestras es:
# 80% entrenamiento; 20% test
[nFeat, nSamples] = size(mInput);
nTr=floor(nSamples*0.8);
nVal=nSamples-nTr;

# Barajado aleatorio de las muestras con los indices random
rand(’seed’,23);
indices=randperm(nSamples);

# Seleccion de las primeras muestras para entrenamiento
mTrainInput=mInput(:,indices(1:nTr));
mTrainOutput=mOutput(indices(1:nTr));
# Seleccion del resto de muestras para validacion
mValiInput=mInput(:,indices((nTr+1):nSamples));
mValiOutput=mOutput(indices((nTr+1):nSamples));



