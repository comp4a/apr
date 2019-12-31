#!/usr/bin/octave -qf

# Cargamos los datos de entrenamiento
load data/mini/tr.dat;          # Muestras entrenamiento (no separable)
load data/mini/trlabels.dat     # Etiquetas entrenamiento (no separable)

N = rows(tr);

# El tipo de kernel "-t 0" corresponde al tipo lineal
# Res es un tipo estructurado que contiene, entre otros:
#   los parámetros del modelo
#   los ı́ndices de los vectores que han resultado ser vectores soporte
#   el multiplicador de Lagrange
C = 1000
res = svmtrain(trlabels, tr, ["-q -t 0 -c ",num2str(C)]);

alpha = res.sv_coef

x = tr(res.sv_indices,:)
c = trlabels(res.sv_indices);
theta =  sum(x .* alpha)

%theta0 = - res.rho
aux = find(theta < c);
theta0 = sign(res.sv_coef(aux(1))) - theta*res.SVs(aux(1),:)'

margen = 2 / norm(theta)
pendiente = - theta(1) / theta(2)

val_x = [0:1:7];
recta = pendiente * val_x + -theta0/theta(2);
recta_margen1 = pendiente * val_x -(theta0 +1)/theta(2);
recta_margen2 = pendiente * val_x -(theta0 -1)/theta(2);

toler = zeros(length(trlabels),1);
for i = 1:length(res.sv_indices)
    toler(res.sv_indices(i))=abs( (abs(alpha(i))==C)*(1 - ( sign(alpha(i)) * (theta*tr(res.sv_indices(i),:)' + theta0) )) ); 
end

plot(   val_x, recta,"color","black",
        val_x, recta_margen1,"color","black","linestyle","--",
        val_x, recta_margen2,"color","black","linestyle","--",
        tr(trlabels==1, 1), tr(trlabels==1, 2), "o","markersize",8,"markerfacecolor","r","markeredgecolor","r",
        tr(trlabels==2, 1), tr(trlabels==2, 2), "o","markersize",8,"markerfacecolor","b","markeredgecolor","b",
        tr(res.sv_indices, 1), tr(res.sv_indices, 2), "o","markeredgecolor","black","markersize",12,
        tr(toler!=0,1),tr(toler!=0,2),"*","markeredgecolor","black","markersize",12
);

for i = 1:rows(tr)
	text(tr(i,1)+0.15,tr(i,2),sprintf("%4.2f",toler(i)),"FontSize",10)
endfor

aux = setdiff([1:rows(tr)],res.sv_indices);
for i = aux
	text(tr(i,1)-0.07,tr(i,2)+0.3,sprintf("0.00"),"FontSize",10)
end

for i = 1:rows(res.sv_indices)
	text(tr(res.sv_indices(i),1)-0.07,tr(res.sv_indices(i),2)+0.3,sprintf("%4.2f",abs(res.sv_coef(i))),"FontSize",10)
endfor

text(0.3,0.3,sprintf("marg = %4.2f",margen),"FontSize",10)


refresh();
print -djpg noSep_chart.jpg;