function tgv_plotData(ax, X, Y, data, plotType, titleText, xlabelText, ylabelText, zlabelText)
    % Generalisierte Plot-Funktion
    if isempty(ax) || ~all(isgraphics(ax))
        error('Ungültiger Achsen-Handle'); % Sicherstellen, dass ax ein gültiger Achsen-Handle ist
    else
        cla(ax); % Aktuellen Plot löschen
    end

    if strcmp(plotType, 'scatter')
        % Ensure data is an m-by-1 vector
        scatter(ax, X(:), Y(:), [], data(:), 'filled'); % Scatter-Plot mit Farben
    elseif strcmp(plotType, 'surf')
        surf(ax, X, Y, data, 'EdgeColor', 'none'); % Oberflächenplot
        zlim(ax, [min(data(:)), max(data(:)) + 1]); % Setze Z-Achsen-Grenzen
    end

    colormap(ax, jet); % Setze Farbkarte auf 'jet'
    tgv_setPlotProperties(ax, titleText, xlabelText, ylabelText, zlabelText); % Setze Plot-Eigenschaften

    if strcmp(plotType, 'surf')
        view(ax, 3); % 3D-Ansicht für Oberflächenplots
    end
end
