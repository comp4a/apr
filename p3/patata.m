addpath("nnet"); # carga la libreria nnet

# carga los datos
load data/hart/tr.dat;
load data/hart/trlabels.dat;
load data/hart/ts.dat;
load data/hart/tslabels.dat;

# transpone los datos porque nnet trabaja con columnas en lugar de filas
mInput = tr';
mOutput = trlabels';
mTestInput = ts';
mTestOutput = tslabels';

[nFeat, nSamples] = size(mInput);
nTr=floor(nSamples*0.8);
nVal=nSamples-nTr;

# Queremos que los datos sean seleccionados de forma aleatoria
rand('seed',23);
indices=randperm(nSamples);

# Conjunto de entrenamiento
mTrainInput=mInput(:,indices(1:nTr));
mTrainOutput=mOutput(indices(1:nTr));
# Conjunto de validacion
mValiInput=mInput(:,indices((nTr+1):nSamples));
mValiOutput=mOutput(indices((nTr+1):nSamples));

# TODO 
function intToVect (index,size)
  return zeros(n)
endfunction