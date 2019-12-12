addpath("nnet");
function [error] = nnexp(tr,trlabels,ts,tslabels,nhidden,nTrPer=0.8,seed=23)
  mInput = tr';
  mOutput = trlabels'; 
  nOutput = length(unique(trlabels));
  mTestInput = ts';
  mTestOutput = tslabels';

  [nFeat, nSamples] = size(mInput);
  nTr=floor(nSamples*nTrPer);
  nTs=nSamples - nTr;
  nVal=nSamples-nTr;

  rand('seed',seed);
  indices=randperm(nSamples);

  mTrainInput=mInput(:,indices(1:nTr));
  mTrainOutput=mOutput(indices(1:nTr));
  mValiInput=mInput(:,indices((nTr+1):nSamples));
  mValiOutput=mOutput(indices((nTr+1):nSamples));

  trainoutDisp = [(mTrainOutput(:,:)==1);(mTrainOutput(:,:)==2)];
  validoutDisp = [(mValiOutput(:,:)==1);(mValiOutput(:,:)==2)];

  [mTrainInputN, cMeanInput, cStdInput] = prestd(mTrainInput);

  VV.P = mValiInput;
  VV.T = validoutDisp;

  VV.P = trastd(VV.P,cMeanInput,cStdInput);

  Pr = minmax(mTrainInputN);
  ss = [nHidden, nOutput];
  trf = {"tansig","logsig"};
  btf = "trainlm";
  blf = "";
  pf = "mse";
  MLPnet = newff(Pr, ss, trf, btf, blf, pf);

  MLPnet.trainParam.show = 10;
  MLPnet.trainParam.epochs = 300;

  net = train(MLPnet, mTrainInputN, trainoutDisp,[],[],VV);

  mTestInputN = trastd(mTestInput,cMeanInput,cStdInput);

  simOut = sim(net, mTestInputN);
  [m,labOut] = max(simOut);
  matches = labOut==mTestOutput;
  acierto = sum(matches) / nSamples;
  error = 100* (1 - acierto);
 endfunction