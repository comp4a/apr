#!/usr/bin/octave -qf

if (nargin!=8)
	printf("Usage: gaussianExp.m <trdata> <trlabels> <tedata> <telabels> <mink> <stepk> <maxk> <alpha> \n");
	exit(1);
endif

arg_list=argv();
trdata=arg_list{1};
trlabs=arg_list{2};
tedata=arg_list{3};
telabs=arg_list{4};
mink=str2num(arg_list{5});
stepk=str2num(arg_list{6});
maxk=str2num(arg_list{7});
alpha=str2num(arg_list{8});

#Carga de los datos
printf("Cargando datos...\n")
load(trdata);
load(trlabs);
load(tedata);
load(telabs);

#Cálculo del error original
printf("d	err original\n")
[r,c] = size(X);
[err] = mixgaussian(X,xl,Y,yl,1,alpha);
printf("%d	%d\n",r,err);



#inicialización de variables
data = [];
[m,W] = pca(X);
x=mink:stepk:maxk;
printf("\nalpha	k errMin ndistriMin\n");

errMin = 100;
kMin =	0;
ndistriMin = 0;
#cálculo del error PCA
for ndistrib = [1, 2, 5, 10, 20]
	column = [];
	for k = x
		#proyeccion de datos a la dimension k
		Xr = W(:,1:k)'*(X-m)';
		Yr = W(:,1:k)'*(Y-m)';
		[err] = mixgaussian(Xr',xl,Yr',yl,ndistrib, alpha);

		#actualizar valor minimo del error para una alpha
		if (err < errMin) 
			errMin = err;
			kMin = k;
			ndistriMin = ndistrib;
		end

		#actualización de variables
		column = [column;  err];
		k = k+stepk;
	end
	data = [data,column];
	printf("%d	%d	%d\n",alpha, kMin,errMin);
end

printf("%d	%d	%d %d\n",alpha, kMin,errMin, ndistriMin);


plot([mink:stepk:maxk],data);
xlabel("Dimensionalidad espacio PCA");
ylabel("Error (%)");
axis([10,100,2,12]);
legend("alpha=0.1","alpha=0.2","alpha=0.5","alpha=0.9","alpha=0.95","alpha=0.99","alpha=1.0");
refresh();
input("Press enter");
print -djpg	mixgaussianExp.jpg