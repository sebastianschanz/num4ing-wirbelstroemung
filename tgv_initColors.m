function colors = tgv_initColors(Y)
    % Farbinitialisierung für die Partikel
    num_repeats = 12;  % Anzahl der Wiederholungen des Farbverlaufs von 0 bis 2*pi
    Y_mod = mod(Y, 2*pi / num_repeats);  % Modulo-Operation für Wiederholung des Farbverlaufs
    Y_norm = (Y_mod - min(Y_mod(:))) / (max(Y_mod(:)) - min(Y_mod(:)));  % Normalisierung
    colors = round(Y_norm * 64);  % Farbskala anpassen (Annahme: colormap hat 64 Farben)

    % Ensure colors is an m-by-1 vector
    colors = colors(:);  % Reshape to a column vector
end
