function tgv_plotTrajectory(ax, traj_X_pos, traj_Y_pos, titleText, xlabelText, ylabelText, options)
    cla(ax); % Aktuellen Plot in der angegebenen Achse löschen
    hold(ax, 'on'); % Plot in der Achse halten

    % Titel und Achsenbeschriftungen setzen
    title(ax, titleText, 'Interpreter', 'latex', 'FontSize', 12);
    xlabel(ax, xlabelText, 'Interpreter', 'latex');
    ylabel(ax, ylabelText, 'Interpreter', 'latex');
    set(ax, 'Color', 'none'); % Hintergrund entfernen

    % Farbschema 'lines' verwenden
    colors = lines(length(traj_X_pos));

    % Plotten der Bahnlinien
    for i = 1:length(traj_X_pos)
        plot(ax, traj_X_pos{i}, traj_Y_pos{i}, '-', 'Color', colors(i, :), 'LineWidth', 1); % Bahnlinie plotten
        text(traj_X_pos{i}(end), traj_Y_pos{i}(end), sprintf('%d', i), 'Color', colors(i, :), 'FontSize', 8, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom'); % Partikelnummer plotten
    end

    % X-Achsenlimits setzen
    xlim(ax, [options.x_min options.x_max]);
    xticks(ax, linspace(options.x_min, options.x_max, options.nticks));
    xticklabels(ax, {'0', '\pi', '2\cdot\pi'});

    % Y-Achsenlimits setzen
    ylim(ax, [options.y_min options.y_max]);
    yticks(ax, linspace(options.y_min, options.y_max, options.nticks));
    yticklabels(ax, {'0', '\pi', '2\cdot\pi'});

    hold(ax, 'off'); % Plot in der Achse freigeben
end
