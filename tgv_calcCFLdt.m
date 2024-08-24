function [dt, CFLmax] = tgv_calcCFLdt(U, V, dt, options)
    % Berechnung der Zeitschrittgröße basierend auf der CFL-Bedingung
    % U, V: Geschwindigkeitsfelder in x- und y-Richtung
    % dx, dy: Gitterabstand in x- und y-Richtung
    % CFL: CFL-Zahl
    dx = options.dx; dy = options.dy; CFL = options.cfl; dtmax = 0.1;

    CFLx = abs(U) .* dt ./ dx;
    CFLy = abs(V) .* dt ./ dy;
    CFLmax = max(max(CFLx,[],"all"), max(CFLy,[],"all"));

    % Berechnung von dt_x und dt_y
    dt_x = (dx * CFL) / max(max(abs(U)));
    dt_y = (dy * CFL) / max(max(abs(V)));
    
    % Kleineren Zeitschritt auswählen
    dt = min(dt_x, dt_y);
    if dt > dtmax
        dt = dtmax;
    end
end