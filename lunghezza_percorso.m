function [dist] = lunghezza_percorso(percorso,mat_dist)
%
% [dist] = lunghezza_percorso(percorso,mat_dist)
% 
% Funzione per il calcolo della lunghezza di un percorso
%
% INPUTS:
% percorso = vettore contenente i nodi del percorso chiuso di cui si vuole
% calcolare la lunghezza
% mat_dist = matrice delle distanze dei nodi
%
% OUTPUTS:
% dist = lunghezza del percorso

dist=0;

for i = 1:length(percorso)-1
    dist= dist + mat_dist(percorso(i),percorso(i+1));
end

end