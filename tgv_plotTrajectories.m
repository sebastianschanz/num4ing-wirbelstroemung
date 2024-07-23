function tgv_plotTrajectories(ax, traj_X_pos, traj_Y_pos, titleText, xlabelText, ylabelText, options)
    % Plot Funktion für die Bahnlinien
    cla(ax); % Plot löschen
    hold(ax, 'on'); % Plot in der Achse halten

    % Titel und Achsenbeschriftungen setzen
    title(ax, titleText, 'Interpreter', 'latex');
    xlabel(ax, xlabelText, 'Interpreter', 'latex');
    ylabel(ax, ylabelText, 'Interpreter', 'latex');
    axis(ax, 'equal'); % Achsenverhältnis beibehalten
    set(ax, 'Color', 'none'); % Hintergrund entfernen
    set(ax, 'FontSize', options.imgScale*options.fontSize);
    set(get(ax, 'Title'), 'FontSize', options.imgScale*(options.fontSize+2));

    % Farbschema 'lines' verwenden
    colors = lines(length(traj_X_pos));

    % Plotten der Bahnlinien
    for i = 1:length(traj_X_pos)
        plot(ax, traj_X_pos{i}, traj_Y_pos{i}, '-', 'Color', colors(i, :), ...
        'LineWidth', options.imgScale*1); % Bahnlinie plotten
        if options.numParticles <= 30
            % Startposition der Partikel plotten
            plot(ax, traj_X_pos{i}(1), traj_Y_pos{i}(1), 'x', 'Color', colors(i, :), ...
            'MarkerSize', options.imgScale*5,'LineWidth', options.imgScale*1); % Startpunkt plotten
            % Aktuelle Position der Partikel plotten
            plot(ax, traj_X_pos{i}(end), traj_Y_pos{i}(end), 'o', 'Color', colors(i, :), ...
            'MarkerSize', options.imgScale*3, 'MarkerFaceColor', colors(i, :)); % Endpunkt plottens
            text(traj_X_pos{i}(end), traj_Y_pos{i}(end)+0.15, sprintf('%d', i), 'Color', colors(i, :), ...
            'FontSize', options.imgScale*8, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom'); % Partikelnummer plotten
        end
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