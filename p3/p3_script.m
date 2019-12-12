arglist = argv()

if len(arglist) < 5
  print("Usage: tr trlabels ts tslabels nhidden [nTrPer] [seed]");
  exit();
endif
tr = arglist(0);
trlabels = arglist(1);
ts = arglist(2);
tslabels = arglist(3);
nhidden = arglist(4);
if len(arglist) > 5
  nTrPer = arglist(5)
  if len(arglist) > 6
    seed = arglist(6);
    error = nnexp(tr,trlabels,ts,tslabels,nhidden,nTrPer,seed)
  endif
  else
    error = nnexp(tr,trlabels,ts,tslabels,nhidden,nTrPer)
  endif
endif
else
  error = nnexp(tr,trlabels,ts,tslabels,nhidden)
endif

print(error)