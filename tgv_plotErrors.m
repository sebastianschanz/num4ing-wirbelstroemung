function pos_err_std = tgv_plotErrors(ax, pos_err_abs, t, titleText, ylabelText, options)
    if t == 0
        t = 0.01;
    end

    color = [1,0.2,0]; % Farbe für den Boxplot
    % Diese Funktion plottet die Fehler der Partikelpositionen in einem horizontalen Boxchart
    cla(ax); % Aktuellen Plot löschen
    pos_err_abs = pos_err_abs(:); % Fehlervektor in Spaltenvektor umwandeln
    
    % Berechne das 99. Perzentil
    quantile_crop = quantile(pos_err_abs, 0.92);
    
    % Filtere die Fehlerwerte, die unter dem 92. Perzentil liegen
    pos_err_abs_cropped = pos_err_abs(pos_err_abs <= quantile_crop);
    
    % Berechne die Standardabweichung der gefilterten Fehlerwerte
    pos_err_std = std(pos_err_abs_cropped);
    
    % Erstelle den Boxplot
    boxchart(ax, pos_err_abs, 'Orientation', 'vertical', 'BoxFaceColor', color, 'MarkerColor', color, 'MarkerSize', 5); % Boxplot in roter Farbe plotten    
    title(ax, titleText, 'Interpreter', 'latex', 'FontSize', 12); % Titel setzen
    ylim(ax, [0, options.nu*t]); % x-Achse auf 0 bis 0.03 beschränken
    ylabel(ax, ylabelText, 'Interpreter', 'latex', 'FontSize', 10); % x-Achsenbeschriftung setzen
    % wissenschaftliche Zehnerpotenz für die y-Achse
    ax.YAxis.Exponent = 0;
    % immer 3 Nachkommstellen
    ax.YAxis.TickLabelFormat = '%.3f';
    % immer 3 Ticks auf der y-Achse
    ax.YAxis.TickValues = linspace(0, options.nu*t, options.nticks+2);
    % Entferne die y-Achse und den Hintergrund
    set(ax, 'xtick', []); % y-Achsenticks entfernen
    set(ax, 'xticklabel', []); % y-Achsenbeschriftungen entfernen
    set(ax, 'XColor', 'none'); % y-Achsenlinie entfernen
    set(ax, 'Color', 'none'); % Hintergrund entfernen
    ylabel(ax, ''); % y-Achsenlabel entfernen
end
