function plotLagrangeParticles(ax, X_pos, Y_pos, colors, options)
    % Plot der Lagrange-Partikel
    cla(ax);  % Aktuelles Plotfenster löschen
    scatter(ax, X_pos(:), Y_pos(:), [], colors(:), 'filled');  % Scatterplot der Partikel
    colormap(ax, options.colormap);  % Farbkarte einstellen
    xlim(ax, [0 2*pi]);  % X-Achsenlimits setzen
    ylim(ax, [0 2*pi]);  % Y-Achsenlimits setzen
    setPlotProperties(ax, 'Lagrange Partikel', '$x$', '$y$', options);  % Plot-Eigenschaften setzen
end