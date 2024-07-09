function tgv_plotData(ax, X, Y, data, plotType, titleText, xlabelText, ylabelText, zlabelText, options)
    % Generalisierte Plot-Funktion
    % Überprüfen, ob ax ein gültiger Achsen-Handle ist
    if isempty(ax) || ~all(isgraphics(ax))
        error('Ungültiger Achsen-Handle'); % Fehler werfen, wenn ax ungültig ist
    else
        cla(ax); % Aktuellen Plot in der angegebenen Achse löschen
    end

    % Plot-Typ überprüfen und entsprechende Plot-Befehle ausführen
    if strcmp(plotType, 'scatter')
        % Daten müssen ein m-by-1 Vektor sein
        scatter(ax, X(:), Y(:), [], data(:), 'filled'); % Scatter-Plot mit Farben erstellen
    elseif strcmp(plotType, 'surf')
        surf(ax, X, Y, data, 'EdgeColor', 'none'); % Oberflächenplot erstellen
        zlim(ax, [min(data(:)), max(data(:)) + 1]); % Z-Achsen-Grenzen setzen
    end

    % Farbkarte auf 'jet' setzen
    colormap(ax, jet); 
    % Plot-Eigenschaften setzen (Titel, Achsenbeschriftungen)
    tgv_setPlotProperties(ax, titleText, xlabelText, ylabelText, zlabelText, options);

    % 3D-Ansicht für Oberflächenplots setzen
    if strcmp(plotType, 'surf')
        view(ax, 3); 
    end
end
