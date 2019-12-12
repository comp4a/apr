#######
# 2.1 #
#######
# Añadimos la ruta de la libreria al path de octave
addpath("nnet");
# Número de neuronas que tendrá la red
nHidden = 1;
# Neuronas en la capa de salida (Tantas como clases)
nOutput = 0;


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
nOutput = length(unique(trlabels));
mTestInput = ts';
mTestOutput = tslabels';

# La proporcion en el uso de las muestras es:
# 80% entrenamiento; 20% test
[nFeat, nSamples] = size(mInput);
nTr=floor(nSamples*0.8);
nTs=nSamples - nTr;
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
validoutDisp = [(mValiOutput(:,:)==1);(mValiOutput(:,:)==2)];

# Normalizacion de los datos (mean = 0; stdDev = 1)
[mTrainInputN, cMeanInput, cStdInput] = prestd(mTrainInput);

# Estructura especial de representacion
# P -> Datos de entrada; T -> Datos de salida
VV.P = mValiInput;
VV.T = validoutDisp;

# Normalizacion de los datos de validacion partiendo de la media
# y la desviacion tipica del conjunto de entrenamiento
VV.P = trastd(VV.P,cMeanInput,cStdInput);

#######
# 2.4 #
#######
# Matriz Dx2 con los valores máximo y mínimo de cada dimensión
Pr = minmax(mTrainInputN);
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
MLPnet = newff(Pr, ss, trf, btf, blf, pf);

# Una vez creada la red establecemos parámetros de entrenamiento como...
# ...cada cuantas epochs se muestra información
MLPnet.trainParam.show = 10;
# ...número máximo de epochs que se realizarán
MLPnet.trainParam.epochs = 300;

# Entrenamos la red
net = train(MLPnet, mTrainInputN, trainoutDisp,[],[],VV);

#######
# 2.5 #
#######
# Normalización de los datos de test
mTestInputN = trastd(mTestInput,cMeanInput,cStdInput);

# Clasificación
simOut = sim(net, mTestInputN);
# Obtención de las etiquetas calculadas
[m,labOut] = max(simOut);
# Cálculo del error
matches = labOut==mTestOutput;
acierto = sum(matches) / nSamples;
error = 100* (1 - acierto)
 