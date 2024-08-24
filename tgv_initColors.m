function colors = tgv_initColors(Y, options)
    % Farbinitialisierung für die Partikel
    num_repeats = 12;  % Anzahl der Wiederholungen des Farbverlaufs von 0 bis 2*pi
    yMod = mod(Y, options.yMax / num_repeats);  % Modulo-Operation für Wiederholung des Farbverlaufs
    yNorm = (yMod - min(yMod(:))) / (max(yMod(:)) - min(yMod(:)));  % Normalisierung
    colors = round(yNorm * 64);  % Farbskala anpassen (Annahme: colormap hat 64 Farben)
    colors = colors(:);  % Spaltenvektor erstellen
end