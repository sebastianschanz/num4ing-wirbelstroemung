%%% Projekt Wirbelströmung %%%     
%%%   TAYLOR-GREEN-WIRBEL  %%%

%%% Gruppe nm Y
%%% Fabian Schmitt              492849, 
%%% Leon Benjamin Wagner        498829, 
%%% Sebastian Schanz            482121,
%%% Tristan Johannes Schefold   489395

main_fkt()

% Hauptprogramm
function main_fkt
    % Initialisieren des 'options'-structs
    options.nu = double(0.01);    % Kinematische Viskosität
    options.t_end = double(5); % Endzeit
    options.t_nr = uint16(100); % Anzahl der Zeitschritte
    options.x_nr = uint16(100); % Auflösung in x-Richtung
    options.y_nr = uint16(100); % Auflösung in y-Richtung

    % Analytische Lösung des Taylor-Green-Wirbels
    Taylor_Green_Wirbel(options)
end