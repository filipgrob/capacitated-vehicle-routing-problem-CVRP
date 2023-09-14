function [percorso_out, min_length] = two_opt(percorso,matdist)
%
% [percorso_out, min_length] = two_opt(percorso,matdist)
%
% Metodo iterativo di ricerca locale 2-opt per il miglioramento di una 
% soluzione del problema TSP
%
% INPUTS:
% percorso = vettore contenente i nodi di un percorso chiuso
% matdist = matrice delle distanze tra i nodi
%
% OUTPUTS:
% percorso_out = vettore contenente i nodi del percorso ottimizzato
% min_length = lunghezza percorso ottimizzato

%Setto flag per il criterio di stop
trovato_nuovo=1;

while trovato_nuovo
    %Inizializzo matrice dei neighbours
    nuovo_percorso=percorso;
    %Ciclo per trovare tutti i neighbours di un percorso
    for i=1:(length(percorso)-3)
        for j=i+2:(length(percorso)-1)
            %evito ciclo inverso
            if i==1 && j==length(percorso)-1
                continue
            end
            %Aggiungo il neighbour trovato alla lista dei neighbours
            nuovo_percorso(end+1,:)=[percorso(1:i) rot90(percorso(i+1:j),2) percorso(j+1:end)];
        end
    end
    
    %Calcolo lunghezza dei percorsi neighbours
    dist_2opt=zeros(size(nuovo_percorso,1),1);
    for i=1:size(nuovo_percorso,1)
        dist_2opt(i)=lunghezza_percorso(nuovo_percorso(i,:),matdist);
    end
    
    %Trovo il percorso con lunghezza minima
    [min_length, index_min] = min(dist_2opt);
    percorso=nuovo_percorso(index_min,:);

    %Esco quando i percorsi non migliorano più
    if index_min==1
        trovato_nuovo=0;
        percorso_out = percorso;
    end
end

end
