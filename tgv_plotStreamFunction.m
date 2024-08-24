function tgv_plotStreamFunction(ax, X, Y, Psi, titleText, xlabelText, ylabelText, zlabelText, options, colorScheme, xRange, yRange, zRange)
    % Plot Funktion für die Stromfunktion
    cla(ax); % Aktuellen Plot in der angegebenen Achse löschen
    surf(ax, X, Y, Psi, 'EdgeColor', 'none'); % Oberflächenplot erstellen
    title(ax, titleText, 'Interpreter', 'latex'); % Titel setzen
    xlabel(ax, xlabelText, 'Interpreter', 'latex'); % X-Achsenbeschriftung
    ylabel(ax, ylabelText, 'Interpreter', 'latex'); % Y-Achsenbeschriftung
    zlabel(ax, zlabelText, 'Interpreter', 'latex'); % Z-Achsenbeschriftung
    axis(ax, 'square'); % Achsenverhältnis beibehalten
    %set(ax, 'Color', 'none'); % Hintergrund entfernen
    set(ax, 'FontSize', options.imgScale*options.fontSize);
    set(get(ax, 'Title'), 'FontSize', options.imgScale*(options.fontSize+2));
    view(ax, 3); % 3D-Ansicht für Oberflächenplots setzen

    % Colormap setzen
    if exist('colorScheme', 'var') && ~isempty(colorScheme)
        colormap(ax, colorScheme);
    else
        colormap(ax, options.colormap);
    end

    % X-Achsenlimits setzen
    if exist('xRange', 'var') && ~isempty(xRange)
        xlim(ax, xRange);
        xticks(ax, linspace(xRange(1), xRange(2), options.nticks));
        xticklabels(ax, {xRange(1), xRange(2)});
    else
        xlim(ax, [options.xMin options.xMax]);
        xticks(ax, linspace(options.xMin, options.xMax, options.nticks));
        xticklabels(ax, {'0', '\pi', '2\cdot\pi'});
    end

    % Y-Achsenlimits setzen
    if exist('yRange', 'var') && ~isempty(yRange)
        ylim(ax, yRange);
        yticks(ax, linspace(yRange(1), yRange(2), options.nticks));
        yticklabels(ax, {yRange(1), yRange(2)});
    else
        ylim(ax, [options.yMin options.yMax]);
        yticks(ax, linspace(options.yMin, options.yMax, options.nticks));
        yticklabels(ax, {'0', '\pi', '2\cdot\pi'});
    end

    % Z-Achsenlimits setzen, falls vorhanden
    if exist('zRange', 'var') && ~isempty(zRange)
        zlim(ax, zRange);
        zticks(ax, linspace(zRange(1), zRange(2), options.nticks));
    else
        zlim(ax, [options.zMin options.zMax]);
        zticks(ax, linspace(options.zMin, options.zMax, options.nticks));
    end
end
