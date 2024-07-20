function tgv_plotStreamFunction(ax, X, Y, Psi, titleText, xlabelText, ylabelText, zlabelText, options, colorScheme, xRange, yRange, zRange)
    % Plot Funktion für die Stromfunktion
    cla(ax); % Aktuellen Plot in der angegebenen Achse löschen
    surf(ax, X, Y, Psi, 'EdgeColor', 'none'); % Oberflächenplot erstellen
    set(ax, 'Color', 'none'); % Hintergrund entfernen
    view(ax, 3); % 3D-Ansicht für Oberflächenplots setzen
    
    title(ax, titleText, 'Interpreter', 'latex', 'FontSize', 12); % Titel setzen
    xlabel(ax, xlabelText, 'Interpreter', 'latex'); % X-Achsenbeschriftung
    ylabel(ax, ylabelText, 'Interpreter', 'latex'); % Y-Achsenbeschriftung
    zlabel(ax, zlabelText, 'Interpreter', 'latex'); % Z-Achsenbeschriftung

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
        xlim(ax, [options.x_min options.x_max]);
        xticks(ax, linspace(options.x_min, options.x_max, options.nticks));
        xticklabels(ax, {'0', '\pi', '2\cdot\pi'});
    end

    % Y-Achsenlimits setzen
    if exist('yRange', 'var') && ~isempty(yRange)
        ylim(ax, yRange);
        yticks(ax, linspace(yRange(1), yRange(2), options.nticks));
        yticklabels(ax, {yRange(1), yRange(2)});
    else
        ylim(ax, [options.y_min options.y_max]);
        yticks(ax, linspace(options.y_min, options.y_max, options.nticks));
        yticklabels(ax, {'0', '\pi', '2\cdot\pi'});
    end

    % Z-Achsenlimits setzen, falls vorhanden
    if exist('zRange', 'var') && ~isempty(zRange)
        zlim(ax, zRange);
        zticks(ax, linspace(zRange(1), zRange(2), options.nticks));
    else
        zlim(ax, [options.z_min options.z_max]);
        zticks(ax, linspace(options.z_min, options.z_max, options.nticks));
    end
end
