#!/usr/bin/octave -qf

if (nargin!=7)
	printf("Usage: gaussianExp.m <trdata> <trlabels> <tedata> <telabels> <mink> <stepk> <maxk>\n");
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

#Carga de los datos
printf("Cargando datos...\n")
load(trdata);
load(trlabs);
load(tedata);
load(telabs);

#Cálculo del error original
printf("d	err original\n")
[r,c] = size(X);
[err] = gaussian(X,xl,Y,yl,1.0);
printf("%d	%d\n",r,err);



#inicialización de variables
data = [];
[m,W] = pca(X);
x=mink:stepk:maxk;
printf("\nalpha	k errMin\n")

#cálculo del error PCA
for a = [0.1,0.2,0.5,0.9,0.95,0.99,1.0]
	errMin = 100;
	kMin =	0;
	column = [];
	for k = x
		#proyeccion de datos a la dimension k
		Xr = W(:,1:k)'*(X-m)';
		Yr = W(:,1:k)'*(Y-m)';
		[err] = gaussian(Xr',xl,Yr',yl,a);

		#actualizar valor minimo del error para una alpha
		if (err < errMin) 
			errMin = err;
			kMin = k;
		end

		#actualización de variables
		column = [column;  err];
		k = k+stepk;
	end
	data = [data,column];
	printf("%d	%d	%d\n",a, kMin,errMin);
end


plot([mink:stepk:maxk],data);
xlabel("Dimensionalidad espacio PCA");
ylabel("Error (%)");
axis([10,100,2,12]);
legend("a=0.1","a=0.2","a=0.5","a=0.9","a=0.95","a=0.99","a=1.0");
refresh();
input("Press enter");
print -djpg	gaussianExp.jpg