function tgv_setPlotProperties(ax, titleText, xlabelText, ylabelText, options)
    % Plot-Einstellungen
    title(ax, titleText, 'Interpreter', 'latex', 'FontSize', 12);  % Titel setzen
    xlabel(ax, xlabelText, 'Interpreter', 'latex');  % X-Achsenbeschriftung
    ylabel(ax, ylabelText, 'Interpreter', 'latex');  % Y-Achsenbeschriftung
    xlim(ax, [0 2*pi]);  % X-Achsenlimits setzen
    xticks(ax, [0 pi 2*pi]);
    xticklabels(ax, {'0', '\pi', '2\cdot\pi'});
    ylim(ax, [0 2*pi]);  % Y-Achsenlimits setzen
    yticks(ax, [0 pi 2*pi]);
    yticklabels(ax, {'0', '\pi', '2\cdot\pi'});
    zlim(ax, [-30 30]);  % Z-Achsenlimits setzen
    zticks(ax, [-30:10:30]);

    % Set z-axis label if provided
    if isfield(options, 'zlabelText')
        zlabel(ax, options.zlabelText, 'Interpreter', 'latex');
    end
end