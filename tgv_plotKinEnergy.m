function tgv_plotKinEnergy(ax, time, E_kin_n, E_kin_a, options)
    % Energieverläufe plotten
    cla(ax); % Plot löschen
    hold(ax, 'on'); % Plot in der Achse halten
    plot(ax, time, E_kin_n, 'LineWidth', 1.5, 'DisplayName', 'numerisch');
    plot(ax, time, E_kin_a, 'LineWidth', 1.5, 'DisplayName', 'analytisch');
    grid(ax, 'on');
    title(ax, 'Energiedissipation', 'Interpreter', 'latex');
    xlabel(ax, 'Zeit $t$', 'Interpreter', 'latex');
    xticks(ax, linspace(0, options.t_end, options.nticks));
    xlim(ax, [0, options.t_end]);
    ylabel(ax, '$E_{kin}$', 'Interpreter', 'latex');
    yticks(ax, linspace(-20, 20, options.nticks));
    ylim(ax, [-20, 20]);
    legend(ax, 'Location', 'northeast', 'Interpreter', 'latex');
    hold(ax, 'off'); % Plot in der Achse freigeben
end
