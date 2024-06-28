%%% Projekt Wirbelströmung %%%     
%%%   TAYLOR-GREEN-WIRBEL  %%%

%%% Gruppe nm Y
%%% Fabian Schmitt              492849, 
%%% Leon Benjamin Wagner        498829, 
%%% Sebastian Schanz            482121,
%%% Tristan Johannes Schefold   489395

main()

% Hauptprogramm
function main
    % Initialize 'options' structure with fields of specific types
    options.nu = double(0);    % Kinematische Viskosität
    options.t_end = double(5); % Endzeit
    options.t_nr = uint16(100); % Anzahl der Zeitschritte
    options.x_nr = uint16(100); % Auflösung in x-Richtung
    options.y_nr = uint16(20);  % Auflösung in y-Richtung

    % Pass the 'options' structure to the 'Taylor_Green_Wirbel' function
    Taylor_Green_Wirbel(options);
end