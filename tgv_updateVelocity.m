function [U, V] = tgv_updateVelocity(Psi, options)
    % Erzeugung des Boolschen Vektors W
    W = ones(options.x_nr, options.y_nr); W(2:end-1, 2:end-1) = 0;

    % Randgeschwindigkeitsvektor 
    u_Rand = zeros(options.x_nr, options.y_nr);
    u_Rand(1, :) = options.U_Wand(2);        % obere Reihe
    u_Rand(options.x_nr, :) = options.U_Wand(4);        % untere Reihe
    u_Rand(:, 1) = options.U_Wand(1);        % erste Spalte
    u_Rand(:, options.y_nr) = options.U_Wand(3);        % letzte Spalte

    v_Rand = zeros(options.x_nr, options.y_nr);
    v_Rand(1, :) = options.V_Wand(2);        % obere Reihe
    v_Rand(options.x_nr, :) = options.V_Wand(4);        % untere Reihe
    v_Rand(:, 1) = options.V_Wand(1);        % erste Spalte
    v_Rand(:, options.y_nr) = options.V_Wand(3);        % letzte Spalte

    % Berechnung der Geschwindigkeitskomponenten aus der Stromfunktion Psi
    [dPsidx, dPsidy] = gradient(Psi);  % Berechnung der Gradienten der Stromfunktion
    U = reshape(~W(:) .* (dPsidy(:)) + W(:) .* u_Rand(:) ,[options.x_nr, options.y_nr]);  % Geschwindigkeit U aus der Stromfunktion
    V = reshape(~W(:) .* (-dPsidx(:)) + W(:) .* v_Rand(:) ,[options.x_nr, options.y_nr]);  % Geschwindigkeit V aus der Stromfunktion
end