%
% Mixture of gaussians
%
% X  is a n x d training data matrix 
% xl is a n x 1 training label vector 
% Y is a m x d test data matrix
% yl is a m x 1 test label vector 
% K is the number of components per mixture
% alpha is the weight of the full variance matrix (1-alpha identity matrix)
function [teerr] = mixgaussian(X,xl,Y,yl,K,alpha)

rand('seed',23);
classes=unique(xl);
C=rows(classes);
N=rows(X);
M=rows(Y);
D=columns(X);

% Estimation of class priors as histogram counts
pc=histc(xl,classes)/N;

% Initialization of mixture of gaussians based on parameter initialization
sigma=cell(C,K);
for c=classes'
  ic=find(c==classes); % fila a la que corresponde la clase c
  % Initialization of component priors p(k|c) as uniform distro
  pkGc{ic}(1:K)=1/K; % Inicializar la probabilidad condicionada. Equivaldría a la probabilidad de que un dato de la clase c se haya generado con la distrib k.
  % Initialization of K component means mu_kc as K random samples from class c
  idc=find(xl==c); % Sacar el índice de las muestras de clase c
  Nc=rows(idc); % sacar núm elem de la clase c
  mu{ic}=X(idc(randperm(Nc,K)),:)'; % cálculo de la media de la clase c.
  % Initialization of K component covariance sigma_kc 
  % as K class covariance matrix divided by the number of components K 
  sigma(ic,1:K)=cov(X(idc,:),1)/K; % Creación de matriz de covar.
end

% Convergence condition to stop EM
% While likelihood relative increase greater than epsilon, keep iterating
epsilon = 1e-4;
L=-inf;
it=0;
printf(" It          oL           L trerr teerr\n");
printf("--- ----------- ----------- ----- -----\n");
do 
  oL=L;L=0;

  % For each class	  
  for c=classes' % classes es un vector tipo [1,2,3,...,C] de las distintas clases que hay
    % E step: Estimate zk
    ic=find(c==classes); % Encontrar qué fila corresponde a la clase c
    idc=find(xl==c); % Cogemos los índices de dónde están las muestras de la clase c
    Nc=rows(idc); % Sacar núm muestras de clase c
    Xc=X(idc,:); % Sacar muestras de la clase c
    zk=[];
    for k=1:K
      zk(:,k)=compute_zk(ic,k,pkGc,mu,sigma,Xc); % ic = fila| k = distribución | 
    end
    % Robust computation of znk and log-likelihood
    maxzk=max(zk,[],2);
    zk=exp(zk-maxzk);
    sumzk=sum(zk,2);
    zk=zk./sumzk;
    L=L+Nc*log(pc(ic))+sum(maxzk+log(sumzk));

    %**************************
    % M step: parameter update
    %**************************

    % cálculo de Pck(t+1):
    pkGc{ic} = (1/Nc) * sum(zk);

    % cálculo de muCk(t+1):
    mu{ic} = (Xc'*zk) ./ sum(zk);

    % cálculo sigma ck(t+1):
    for k=1:K
      XcmenosMedia = (Xc - mu{ic}(:,k)');

      sigmaAux = (((zk(:,k) .* XcmenosMedia)' * XcmenosMedia) ) ./ sum(zk(:,k));

      % Suavizado de la matriz
      sigmaAux = alpha * sigmaAux + (1-alpha)*eye(columns(Xc));
      sigma{ic,k} = sigmaAux;

    end  

  end
  % Likelihood divided by the number of training samples
  L=L/N;

  % Compute g for training and test sets
  for c=classes'
    ic=find(c==classes);
    % Training set
    zk=[];
    for k=1:K
      zk(:,k)=compute_zk(ic,k,pkGc,mu,sigma,X);
    end
    % Robust computation of znk
    maxzk=max(zk,[],2);
    zk=exp(zk-maxzk);
    sumzk=sum(zk,2);
    gtr(:,ic)=log(pc(ic))+maxzk+log(sumzk);

    % Test set
    zk=[];
    for k=1:K
      zk(:,k)=compute_zk(ic,k,pkGc,mu,sigma,Y);
    end
    % Robust computation of znk
    maxzk=max(zk,[],2);
    zk=exp(zk-maxzk);
    sumzk=sum(zk,2);
    gte(:,ic)=log(pc(ic))+maxzk+log(sumzk);
  end

  % Classification of training and test sets and error estimation
  [~,idx]=max(gtr');
  trerr=mean(classes(idx)!=xl)*100;
  [~,idy]=max(gte');
  teerr=mean(classes(idy)!=yl)*100;
  it=it+1;
  printf("%3d %11.5f %11.5f %5.2f %5.2f\n",it,oL,L,trerr,teerr);
  
until ((L-oL)/abs(oL) < epsilon)
end

% Computes component-and-class conditional gaussian prob
function [zk] = compute_zk(ic,k,pkGc,mu,sigma,X)
  D=columns(X);
  cons=log(pkGc{ic}(k));
  cons=cons-0.5*D*log(2*pi);
  cons=cons-0.5*logdet(sigma{ic,k});
  cons=cons-0.5*mu{ic}(:,k)'*pinv(sigma{ic,k})*mu{ic}(:,k);
  lin=X*(mu{ic}(:,k)'*pinv(sigma{ic,k}))';
  qua=-0.5*sum((X*pinv(sigma{ic,k})).*X,2);
  zk=qua+lin+cons;
end

% Robust computation of the logarithm of the determinant of the covariance matrix X
% https://www.adelaide.edu.au/mathslearning/play/seminars/evalue-magic-tricks-handout.pdf
% The det of X is the product of its eigenvalues,
% then the log of the det is the sum of the log of the eigenvalues
% If there are eigenvalues that are zero (or negative),
% then the log of the det is the smallest value
function v = logdet(X)
  lambda = eig(X);
  if any(lambda<=0)
    v=log(eps);
  else
    v=sum(log(lambda));
  end
end
