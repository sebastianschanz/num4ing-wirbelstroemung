function tgv_setPlotProperties(ax, titleText, xlabelText, ylabelText, zlabelText, options)
    % Plot-Einstellungen
    n_marks = 3;  % Anzahl der Markierungen auf den Achsen
    title(ax, titleText, 'Interpreter', 'latex', 'FontSize', 12);  % Titel setzen
    xlabel(ax, xlabelText, 'Interpreter', 'latex');  % X-Achsenbeschriftung
    ylabel(ax, ylabelText, 'Interpreter', 'latex');  % Y-Achsenbeschriftung
    xlim(ax, [options.x_min options.x_max]);  % X-Achsenlimits setzen
    xticks(ax, [linspace(options.x_min, options.x_max, n_marks)]);
    xticklabels(ax, {'0', '\pi', '2\cdot\pi'});
    ylim(ax, [options.y_min options.y_max]);  % Y-Achsenlimits setzen
    yticks(ax, [linspace(options.y_min, options.y_max, n_marks)]);
    yticklabels(ax, {'0', '\pi', '2\cdot\pi'});
    zlim(ax, [options.z_min options.z_max]);  % Z-Achsenlimits setzen
    zticks(ax, [linspace(options.z_min, options.z_max, n_marks)]);

    % Z-Achsenbeschriftung, wenn vorhanden
    if isempty(zlabelText)
        zlabel(ax, zlabelText, 'Interpreter', 'latex');  % Z-Achsenbeschriftung
    end
