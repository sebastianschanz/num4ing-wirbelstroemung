function tgv_plotEnstrophy(ax, time, enst_n, enst_a, options)

    color = [250, 180, 60]/255; % Color for the box plot
    color2 = [65, 105, 250]/255; % Color for the box plot
    % Energieverläufe plotten
    cla(ax); % Plot löschen
    hold(ax, 'on'); % Plot in der Achse halten
    title(ax, 'Enstrophie', 'Interpreter', 'latex');
    xlabel(ax, '$t$', 'Interpreter', 'latex');
    ylabel(ax, '$\mathcal{E}$', 'Interpreter', 'latex');

    axis(ax, 'square'); % Achsenverhältnis beibehalten
    set(ax, 'Color', 'none'); % Hintergrund entfernen
    set(ax, 'FontSize', options.imgScale*options.fontSize);
    set(get(ax, 'Title'), 'FontSize', options.imgScale*(options.fontSize+2));

    plot(ax, time, enst_n, '-', 'LineWidth', options.imgScale*1, 'Color', color, 'DisplayName', 'numerisch');
    plot(ax, time, enst_a, '-.', 'LineWidth', options.imgScale*1, 'Color', color2, 'DisplayName', 'analytisch');
    grid(ax, 'on');

    xticks(ax, linspace(0, options.t_end, options.nticks));
    xlim(ax, [0, options.t_end]);
    yticks(ax, linspace(0, 50, options.nticks));
    ylim(ax, [0, 50]);
    legend(ax, 'Location', 'northeast', 'Interpreter', 'latex');
    hold(ax, 'off'); % Plot in der Achse freigeben
end
