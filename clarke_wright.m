function [routes]=clarke_wright(distance,vehicle_capacity,demand,theta)
%
% [routes]=clarke_wright(distance,vehicle_capacity,demand)
%
% Metodo costruttivo di Clarke-Wright per la ricerca di una soluzione sub
% ottimale del problema CVRP. Algoritmo parallelo basato sul
% criterio dei savings
%
% INPUTS:
% distance = matrice delle distanxìze fra i nodi
% vehicle_capacity = valore scalare della capacità di ogni veicolo
% demand = vettore delle domande di ogni nodo
% theta = parametro di penalizzazione strade lunghe
%
% OUTPUTS:
% routes = cell-array contenente i vettori dei diversi percorsi ottenuti

%Se non passo theta lo suppongo nullo
if nargin == 3
    theta = 0;
end

%Trovo numero nodi
dimension=size(distance,1);

%Creo e inizializzo cell-array delle routes
routes = cell(dimension-1,1);
for i = 1:dimension-1
    routes{i} = i+1;
end

%Creo matrice savings
savings = zeros(dimension, dimension);
for i = 2:dimension
    for j = i+1:dimension
        savings(i,j) = distance(i,1) + distance(1,j) - (theta+1)*distance(i,j);
    end
end

%Inizializzazione
path_1 = 0;
path_2 = 0;
k = 0;  %numero iterazioni

%counter violazione vincoli
capacita_superata = 0;  
stesso_percorso = 0;
non_estremali = 0;

%Ciclo fino a che la matrice dei savings non è nulla
while max(savings,[],'all') > 0  
    
    k = k+1;
    
    %Trovo miglior saving
    max_save = max(savings,[],'all');
    [i,j] = find(savings==max_save);
    
    %Gestione ties
    i = i(1);
    j = j(1);
    
    %Setto a 0 il saving considerato
    savings(i,j) = 0;
    
    %Cerco se ci sono due feasible path che contengono i e j
    for el = 1:length(routes)
        if routes{el}(1) == i 
            path_1 = routes{el};
            flag_1 = 0;  %flag se i si trova a inizio (0) o fine (1) path
            pos_1 = el;
        elseif routes{el}(end) == i
            path_1 = routes{el};
            flag_1 = 1;
            pos_1 = el;
        elseif routes{el}(1) == j 
            path_2 = routes{el};
            flag_2 = 0; %flag se j si trova a inizio (0) o fine (1) path
            pos_2 = el;
        elseif routes{el}(end) == j
            path_2 = routes{el};
            flag_2 = 1;
            pos_2 = el;
        end
    end

    % Controllo se i e j sono nodi estremali di percorsi
    if sum(path_1) == 0 || sum(path_2) == 0
        non_estremali = non_estremali+1;
        continue
    end
    
    %Controllo se i e j appartengono allo stesso percorso
    if path_1(1) == path_2(1) || path_1(1) == path_2(end)
        stesso_percorso = stesso_percorso+1;
        continue 
    end

    %Controllo vincolo capacità
    if sum(demand(path_1)) + sum(demand(path_2)) > vehicle_capacity
        capacita_superata = capacita_superata +1;
        continue
    end

    %Unione path di i e j in base ai casi
    if flag_1 == 0
        if flag_2 == 0
            path_2 = rot90(path_2,2);  %ruoto il path_2 perchè voglio che j sia a fine del path 2 (essendo i all'inizio del path 1)
            new_path = path_2;
            new_path(end+1:end+length(path_1)) = path_1;
            routes{pos_1} = new_path;
            routes(pos_2) = [];
        elseif flag_2 == 1
            new_path = path_2;
            new_path(end+1:end+length(path_1)) = path_1;
            routes{pos_1} = new_path;
            routes(pos_2) = [];
        end
    elseif flag_1 == 1
        if flag_2 == 0
            new_path = path_1;
            new_path(end+1:end+length(path_2)) = path_2;
            routes{pos_1} = new_path;
            routes(pos_2) = [];
        elseif flag_2 == 1
            path_2 = rot90(path_2,2);
            new_path = path_1;
            new_path(end+1:end+length(path_2)) = path_2;
            routes{pos_1} = new_path;
            routes(pos_2) = [];
        end
    end
    
    %Reset dei path
    path_1 = 0;
    path_2 = 0;  
end

%Aggiungiamo il deposito a inizio e fine di ogni percorso
for i=1:length(routes)
    routes{i}=[1 routes{i} 1];
end

end