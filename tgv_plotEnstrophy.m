function tgv_plotEnstrophy(ax, time, enst_n, enst_a, options)
    % Energieverläufe plotten
    cla(ax); % Plot löschen
    hold(ax, 'on'); % Plot in der Achse halten
    plot(ax, time, enst_n, 'LineWidth', 1.5, 'DisplayName', 'numerisch');
    plot(ax, time, enst_a, 'LineWidth', 1.5, 'DisplayName', 'analytisch');
    grid(ax, 'on');
    title(ax, 'Enstrophie', 'Interpreter', 'latex');
    xlabel(ax, 'Zeit $t$', 'Interpreter', 'latex');
    xticks(ax, linspace(0, options.t_end, options.nticks));
    xlim(ax, [0, options.t_end]);
    ylabel(ax, '$\mathcal{E}$', 'Interpreter', 'latex');
    yticks(ax, linspace(0, 100, options.nticks));
    ylim(ax, [0, 100]);
    legend(ax, 'Location', 'northeast', 'Interpreter', 'latex');
    hold(ax, 'off'); % Plot in der Achse freigeben
end
