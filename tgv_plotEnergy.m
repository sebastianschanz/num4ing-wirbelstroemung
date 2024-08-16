function tgv_plotEnergy(ax, time, enst_n, enst_a, energy_n, energy_a, options)

    color1 = [250, 180, 60]/255; % Color for the box plot
    color2 = [65, 105, 250]/255; % Color for the box plot
    color3 = [255, 0, 0]/255; % Color for the box plot
    color4 = [150, 0, 150]/255; % Color for the box plot
    % Energieverläufe plotten

    cla(ax); % Plot löschen
    hold(ax, 'on'); % Plot in der Achse halten
    title(ax, 'Kin. Energie', 'Interpreter', 'latex');
    xlabel(ax, '$t$', 'Interpreter', 'latex');
    ylabel(ax, '$E_{Kin}$', 'Interpreter', 'latex');

    axis(ax, 'square'); % Achsenverhältnis beibehalten
    set(ax, 'Color', 'none'); % Hintergrund entfernen
    set(ax, 'FontSize', options.imgScale*options.fontSize);
    set(get(ax, 'Title'), 'FontSize', options.imgScale*(options.fontSize+2));

    plot(ax, time, energy_n, '-', 'LineWidth', options.imgScale*1, 'Color', color1, 'DisplayName', 'kin. Energie numerisch');
    plot(ax, time, energy_a, '-.', 'LineWidth', options.imgScale*1, 'Color', color2, 'DisplayName', 'kin. Energie analytisch');
    plot(ax, time, enst_n, '-', 'LineWidth', options.imgScale*1, 'Color', color3, 'DisplayName', 'Entstrophie numerisch');
    plot(ax, time, enst_a, '-.', 'LineWidth', options.imgScale*1, 'Color', color4, 'DisplayName', 'Entstrophie analytisch');
    grid(ax, 'on');

    xticks(ax, linspace(0, options.t_end, options.nticks));
    xlim(ax, [0, options.t_end]);
    yticks(ax, linspace(-5, 5, options.nticks));
    ylim(ax, [-5, 10]);
    lgd = legend(ax, 'Location', 'northeast', 'Interpreter', 'latex');
    lgd.FontSize = lgd.FontSize / 2;
    hold(ax, 'off'); % Plot in der Achse freigeben
end
