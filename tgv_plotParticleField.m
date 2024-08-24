function tgv_plotParticleField(ax, X_pos, Y_pos, colors, titleText, xlabelText, ylabelText, options, colorScheme, xRange, yRange)
    % Plot Funktion für das Partikelfeld
    cla(ax); % Aktuellen Plot in der angegebenen Achse löschen
    scatter(ax, X_pos(:), Y_pos(:), options.imgScale*20, colors, 'filled'); % Scatter-Plot mit Farben erstellen
    title(ax, titleText, 'Interpreter', 'latex'); % Titel setzen
    xlabel(ax, xlabelText, 'Interpreter', 'latex'); % X-Achsenbeschriftung
    ylabel(ax, ylabelText, 'Interpreter', 'latex'); % Y-Achsenbeschriftung
    axis(ax, 'square'); % Achsenverhältnis beibehalten andere Optionen sind
    %set(ax, 'Color', 'none'); % Hintergrund entfernen
    set(ax, 'FontSize', options.imgScale*options.fontSize);
    set(get(ax, 'Title'), 'FontSize', options.imgScale*(options.fontSize+2));

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
end