N = 4;
C = 1; S = 2; R = 3; W = 4;
grafo = zeros(N, N);
grafo(C,[R S]) = 1;
grafo(R,W)= 1;
grafo(S,W)= 1;

#draw_graph(grafo);