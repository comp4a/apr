#!/usr/bin/octave -qf

C = 1000;
% TRAIN
load data/MNIST/train-images-idx3-ubyte.mat.gz #X
load data/MNIST/train-labels-idx1-ubyte.mat.gz #xl
% TEST
load data/MNIST/t10k-images-idx3-ubyte.mat.gz %Y
load data/MNIST/t10k-labels-idx1-ubyte.mat.gz %yl

c = 0;
for i = [1]
%    for j = [0.1, 0.5, 1, 5, 10,50,100]
    for j = [2:9]
        c++;
        disp(["-q -t ",num2str(i)," -d ",num2str(j)])
        train = svmtrain(xl, X, ["-q -t ",num2str(i)," -d ",num2str(j)]);
         [predicted_label, accuracy, decision_values] = svmpredict(yl,Y,train,'-q');
        accuracy(1);
        N = size(yl)(1);
        epsilon = 1.96*sqrt( (accuracy(1) / 100 * (1 - accuracy(1) / 100) ) / N);
        disp(["accuracy: ",num2str(accuracy(1)),"\t epsilon: ", num2str(epsilon)])
        disp("-------------------------")
    end
end
