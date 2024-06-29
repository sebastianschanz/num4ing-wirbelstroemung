function setPlotProperties(ax, titleText, xlabelText, ylabelText, options)
    % Plot-Einstellungen
    title(ax, titleText, 'Interpreter', 'latex', 'FontSize', 12);  % Titel setzen
    xlabel(ax, xlabelText, 'Interpreter', 'latex');  % X-Achsenbeschriftung
    ylabel(ax, ylabelText, 'Interpreter', 'latex');  % Y-Achsenbeschriftung
    xlim(ax, [0 2*pi]);  % X-Achsenlimits setzen
    ylim(ax, [0 2*pi]);  % Y-Achsenlimits setzen
    if isfield(options, 'zlabelText')
        zlabel(ax, options.zlabelText, 'Interpreter', 'latex');  % Z-Achsenbeschriftung (falls vorhanden)
    end
end