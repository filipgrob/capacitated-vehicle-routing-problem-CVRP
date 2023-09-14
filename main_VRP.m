clear all
close all
clc

%Caricamento dataset
load('dataset.mat')

%Calcolo matrice delle distanze
distance=dist(coord');

%Inizializzazioni
ris_clark_wright = cell(32,1);
sum_clark_wright = zeros(32,1);
ris_2opt = cell(32,1);
sum_2opt = zeros(32,1);

%Ricerca del miglior iperparametro theta
for k = 1:32  %per valori di k maggiori otteniamo 6 strade

    %Metodo costruttivo Clarke-Wright
    routes=clarke_wright(distance,vehicle_capacity,demand,0.02*(k-1));
    dist_cw = zeros(length(routes),1);
    for t = 1:length(routes)
        dist_cw(t)=lunghezza_percorso(routes{t},distance);
    end
    %Risultati lunghezza percorsi
    ris_clark_wright{k} = routes;
    sum_clark_wright(k) = sum(dist_cw);

    %Metodo iterativo 2-opt 
    routes_2opt=cell(length(routes),1);
    dist_2opt=zeros(length(routes),1);
    for i=1:length(routes)
        [routes_2opt{i},dist_2opt(i)]=two_opt(routes{i},distance);
    end
    %Risultati lughezza percorsi
    ris_2opt{k} = routes_2opt;
    sum_2opt(k) = sum(dist_2opt);
end


%%%%%%%%%%%%
%%% PLOT %%%
%%%%%%%%%%%%

%Troviamo i migliori risultati in generale (CASO 1)
[min_2opt,best] = min(sum_2opt);
routes = ris_clark_wright{best};
routes_2opt = ris_2opt{best};

%Plot dei risultati Clarke&Wright caso 1
names = {'1','2','3','4','5','6','7','8','9','10','11','12','13','14', '15','16','17','18','19','20','21','22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33'};
color=['b', 'g', 'r', 'k', 'y'];
p1 = plot(coord(:,1),coord(:,2), 'k.', 'DisplayName','Nodi');
hold on
text(coord(:,1) - 0.25, coord(:,2) + 0.25, names, 'HorizontalAlignment', 'right');
axis equal
hold on
for k=1:length(routes)
    for i = 1:length(routes{k})-1
        p2(i,i+1) = plot([coord(routes{k}(i),1), coord(routes{k}(i+1),1)], [coord(routes{k}(i),2), coord(routes{k}(i+1),2)], color(k), 'DisplayName','Clarke&Wright');
        hold on
    end
end
title('Soluzione Clarke&Wright caso 1')
grid on
xlabel('Ascisse dei nodi')
ylabel('Ordinate dei nodi')

%Plot dei risultati 2opt caso 1
figure(2)
p1 = plot(coord(:,1),coord(:,2), 'k.', 'DisplayName','Nodi');
hold on
text(coord(:,1) - 0.25, coord(:,2) + 0.25, names, 'HorizontalAlignment', 'right');
axis equal
hold on
for k=1:length(routes_2opt)
    for i = 1:length(routes_2opt{k})-1
        p2(i,i+1) = plot([coord(routes_2opt{k}(i),1), coord(routes_2opt{k}(i+1),1)], [coord(routes_2opt{k}(i),2), coord(routes_2opt{k}(i+1),2)], color(k), 'DisplayName','2opt');
        hold on
    end
end
title('Soluzione 2opt caso 1')
grid on
xlabel('Ascisse dei nodi')
ylabel('Ordinate dei nodi')

%Troviamo miglior risultato clark_wright e applichiamo 2_opt (CASO 2)
[min_clark_wright,best2] = min(sum_clark_wright);
routes = ris_clark_wright{best2};
routes_2opt = ris_2opt{best2};

%Plot dei risultati Clarke&Wright caso 2
figure(3)
p1 = plot(coord(:,1),coord(:,2), 'k.', 'DisplayName','Nodi');
hold on
text(coord(:,1) - 0.25, coord(:,2) + 0.25, names, 'HorizontalAlignment', 'right');
axis equal
hold on
for k=1:length(routes)
    for i = 1:length(routes{k})-1
        p3(i,i+1) = plot([coord(routes{k}(i),1), coord(routes{k}(i+1),1)], [coord(routes{k}(i),2), coord(routes{k}(i+1),2)], color(k), 'DisplayName','Clarke&Wright');
        hold on
    end
end
title('Soluzione Clarke&Wright caso 2')
grid on
xlabel('Ascisse dei nodi')
ylabel('Ordinate dei nodi')

%Plot dei risultati 2opt caso 2
figure(4)
p1 = plot(coord(:,1),coord(:,2), 'k.', 'DisplayName','Nodi');
hold on
text(coord(:,1) - 0.25, coord(:,2) + 0.25, names, 'HorizontalAlignment', 'right');
axis equal
hold on
for k=1:length(routes_2opt)
    for i = 1:length(routes_2opt{k})-1
        p4(i,i+1) = plot([coord(routes_2opt{k}(i),1), coord(routes_2opt{k}(i+1),1)], [coord(routes_2opt{k}(i),2), coord(routes_2opt{k}(i+1),2)], color(k), 'DisplayName','2opt');
        hold on
    end
end
title('Soluzione 2opt caso 2')
grid on
xlabel('Ascisse dei nodi')
ylabel('Ordinate dei nodi')


%Calcolo lunghezza singoli percorsi nei casi 1 e 2 (per Tabella 2)
for i = 1:5
    caso_1(i) = lunghezza_percorso(ris_2opt{best,1}{i,1}, distance);
    caso_2(i) = lunghezza_percorso(ris_2opt{best2,1}{i,1}, distance);
end