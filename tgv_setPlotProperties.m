function tgv_setPlotProperties(ax, titleText, xlabelText, ylabelText, zlabelText, options)
    % Plot-Einstellungen
    title(ax, titleText, 'Interpreter', 'latex', 'FontSize', 12);  % Titel setzen
    xlabel(ax, xlabelText, 'Interpreter', 'latex');  % X-Achsenbeschriftung
    ylabel(ax, ylabelText, 'Interpreter', 'latex');  % Y-Achsenbeschriftung
    xlim(ax, [options.x_min options.x_max]);  % X-Achsenlimits setzen
    xticks(ax, [0 pi 2*pi]);
    xticklabels(ax, {'0', '\pi', '2\cdot\pi'});
    ylim(ax, [options.y_min options.y_max]);  % Y-Achsenlimits setzen
    yticks(ax, [0 pi 2*pi]);
    yticklabels(ax, {'0', '\pi', '2\cdot\pi'});
    zlim(ax, [options.z_min options.z_max]);  % Z-Achsenlimits setzen
    zticks(ax, [-5 0 5]);

    % Set z-axis label if provided
    if isempty(zlabelText)
        zlabel(ax, zlabelText, 'Interpreter', 'latex');  % Z-Achsenbeschriftung
    end
