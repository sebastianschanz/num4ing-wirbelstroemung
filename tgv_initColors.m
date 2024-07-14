function colors = tgv_initColors(Y, options)
    % Farbinitialisierung für die Partikel
    num_repeats = 12;  % Anzahl der Wiederholungen des Farbverlaufs von 0 bis 2*pi
    Y_mod = mod(Y, options.y_max / num_repeats);  % Modulo-Operation für Wiederholung des Farbverlaufs
    Y_norm = (Y_mod - min(Y_mod(:))) / (max(Y_mod(:)) - min(Y_mod(:)));  % Normalisierung
    colors = round(Y_norm * 64);  % Farbskala anpassen (Annahme: colormap hat 64 Farben)
    colors = colors(:);  % Spaltenvektor erstellen
end
