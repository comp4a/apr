#######
# 2.1 #
#######
# Cargado de datos del Corpus Hart
load data/hart/tr.dat;
load data/hart/trlabels.dat;
load data/hart/ts.dat;
load data/hart/tslabels.dat;

#######
# 2.2 #
#######
# Trasponemos los datos para adaptalos a la biblioteca
# nnet trabaja con los datos por columnas, no por filas
mInput = tr';
mOutput = trlabels';
mTestInput = ts';
mTestOutput = tslabels';

# La proporcion en el uso de las muestras es:
# 80% entrenamiento; 20% test
[nFeat, nSamples] = size(mInput);
nTr=floor(nSamples*0.8);
nVal=nSamples-nTr;

# Barajado aleatorio de las muestras con los indices random
rand('seed',23);
indices=randperm(nSamples);

# Seleccion de las primeras muestras para entrenamiento
mTrainInput=mInput(:,indices(1:nTr));
mTrainOutput=mOutput(indices(1:nTr));
# Seleccion del resto de muestras para validacion
mValiInput=mInput(:,indices((nTr+1):nSamples));
mValiOutput=mOutput(indices((nTr+1):nSamples));

#######
# 2.3 #
#######
# Codificacion de las etiquetas al fomato requerido por MLP
trainoutDisp = [(mTrainOutput(:,:)==1);(mTrainOutput(:,:)==2)];
validoutDisp = [(mTrainOutput(:,:)==1);(mTrainOutput(:,:)==2)];

# Normalizacion de los datos (mean = 0; stdDev = 1)
[mTrainInputN, cMeanInput, cStdInput] = prestd(mTrainInput);

# Estructura especial de representacion
# P -> Datos de entrada; P -> Datos de salida
VV.P = mValiInput;
VV.T = validoutDisp;

# Normalizacion de los datos de validacion partiendo de la media
# y la desviacion tipica del conjunto de entrenamiento
VV.P = trastd(VV.P,cMeanInput,cStdInput);

#######
# 2.4 #
#######
# Matriz Dx2 con los valores máximo y mínimo de cada dimensión
Pr = minmax(mTrainInputN();
# Un vector fila con el número de neuronas en cada capa oculta y en la capa de salida
ss = [nHidden, nOutput];
# Lista de funciones de activacion de cada capa
trf = {"tansig","logsig"};
# Algoritmo de entrenamiento de la red neuronal (solo tenemos backprop)
btf = "trainlm";
# Parametro que no se emplea en la version actual
blf = "";
# Funcion objetivo a minimizar (solo tenemos el error cuadratico medio)
pf = "mse";
net = newff(Pr, ss, trf, btf, blf, pf);

