#!/usr/bin/octave -qf
if (nargin!=10)
	printf("Usage: pcaexp.m <trdata> <trlabels> <tedata> <telabels> <mink> <stepk> <maxk> <minl> <stepl> <maxl>\n");
	exit(1);
end

arg_list=argv();

trdata=arg_list{1};
trlabs=arg_list{2};
tedata=arg_list{3};
telabs=arg_list{4};

mink=str2num(arg_list{5});
stepk=str2num(arg_list{6});
maxk=str2num(arg_list{7});

minl=str2num(arg_list{8});
stepl=str2num(arg_list{9});
maxl=str2num(arg_list{10});


load(trdata);
load(trlabs);
load(tedata);
load(telabs);

[m, W] = pca(X);

for k = mink:stepk:maxk
  for l = minl:stepl:maxl
	XR = W(:, 1:k)'*(X-m)';
	YR = W(:, 1:k)'*(Y-m)';
	err = gaussian(XR', xl, YR', yl, l);

	printf("%d\t%d\t%f\t\n", k, l, err);
  endfor
endfor
