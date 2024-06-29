function tgv_plotStreamFunction(ax, X, Y, Psi, options)
    % Plot der Stromfunktion
    cla(ax);  % Aktuelles Plotfenster löschen
    surf(ax, X, Y, Psi, 'EdgeColor', 'none');  % Oberflächenplot der Stromfunktion
    colormap(ax, options.colormap);  % Farbkarte einstellen
    xlim(ax, [0 2*pi]);  % X-Achsenlimits setzen
    ylim(ax, [0 2*pi]);  % Y-Achsenlimits setzen
    zlim(ax, [min(Psi(:)), max(Psi(:)) + 1]);  % Z-Achsenlimits setzen
    tgv_setPlotProperties(ax, 'Stromfunktion', '$x$', '$y$', '$\Psi$');  % Plot-Eigenschaften setzen
    view(ax, 3);  % 3D-Ansicht
end