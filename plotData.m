function plotData(ax, X, Y, data, plotType, titleText, options)
    % Plot-Funktion
    cla(ax);  % Aktuelles Plotfenster löschen
    if strcmp(plotType, 'scatter')
        scatter(ax, X(:), Y(:), [], Y(:), 'filled');  % Scatterplot der Partikel
    elseif strcmp(plotType, 'surf')
        surf(ax, X, Y, data, 'EdgeColor', 'none');  % Oberflächenplot der Daten
        zlim(ax, [min(data(:)), max(data(:)) + 1]);  % Z-Achsenlimits setzen
    end
    colormap(ax, options.colormap);  % Farbkarte einstellen
    setPlotProperties(ax, titleText, '$x$', '$y$', options);  % Plot-Eigenschaften setzen
end