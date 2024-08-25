function tgv_plotEnerstrophy(ax, time, enst_n, enst_a, energy_n, energy_a, options)

    color1 = [255, 210, 50]/255;
    color2 = [240, 90, 0]/255;
    color3 = [80, 170, 250]/255;
    color4 = [60, 30, 160]/255;

    cla(ax); % Plot löschen
    hold(ax, 'on'); % Plot in der Achse halten
    title(ax, 'Energie $E_{Kin}$, Enstrophie $\mathcal{E}$', 'Interpreter', 'latex');
    xlabel(ax, '$t$', 'Interpreter', 'latex');
    ylabel(ax, '$E_{Kin}, \mathcal{E}$', 'Interpreter', 'latex');

    axis(ax, 'square'); % Achsenverhältnis beibehalten
    %set(ax, 'Color', 'none'); % Hintergrund entfernen
    set(ax, 'FontSize', options.imgScale*options.fontSize);
    set(get(ax, 'Title'), 'FontSize', options.imgScale*options.fontSize+1);

    plot(ax, time, energy_a, '-', 'LineWidth', options.imgScale*1.2, 'Color', color1, 'DisplayName', '$E_{Kin}$, ana.');
    plot(ax, time, energy_n, ':', 'LineWidth', options.imgScale*1.2, 'Color', color2, 'DisplayName', '$E_{Kin}$, num.');
    plot(ax, time, enst_a, '-', 'LineWidth', options.imgScale*1.2, 'Color', color3, 'DisplayName', '$\mathcal{E}$, ana.');
    plot(ax, time, enst_n, ':', 'LineWidth', options.imgScale*1.2, 'Color', color4, 'DisplayName', '$\mathcal{E}$, num.');
    grid(ax, 'on');

    xticks(ax, linspace(0, options.tEnd, options.nticks+2));
    xlim(ax, [0, options.tEnd]);
    yticks(ax, linspace(options.ensMin, options.ensMax, options.nticks));
    ylim(ax, [options.ensMin, options.ensMax]);
    lgd = legend(ax, 'Location', 'southeast', 'Interpreter', 'latex', 'FontSize', options.imgScale*options.fontSize-1);
    lgd.EdgeColor = 'none'; % Rand der Legende unsichtbar machen
    lgd.BoxFace.ColorType='truecoloralpha';
    lgd.BoxFace.ColorData=uint8(255*[1 1 1 0.6]');
    lgd.ItemTokenSize = [10, 20]; % Größe der Legendenstriche anpassen
    hold(ax, 'off'); % Plot in der Achse freigeben
end
