function pos_err_std = tgv_plotErrors(ax, pos_err_abs, titleText, options)
    % Funktion zur Erstellung eines Boxplots der absoluten Positionsfehler
    color1 = [255, 210, 50]/255;
    color2 = [240, 90, 0]/255;
    cla(ax); % Achse löschen

    pos_err_abs = pos_err_abs(:); % Fehlerwerte als Spaltenvektor
    pos_err_std = std(pos_err_abs); % Standardabweichung der Fehlerwerte
    pos_err_median = median(pos_err_abs); % Median der Fehlerwerte
    
    % Boxplot erstellen
    boxchart(ax, pos_err_abs, 'Orientation', 'horizontal', 'BoxFaceColor', color2, 'MarkerColor', color2, 'MarkerSize', options.imgScale * 4); % Plot box plot in red color
    title(ax, titleText, 'Interpreter', 'latex'); % Titel setzen
    xlim(ax, [options.posMin, options.posMax]); % X-Achsenbereich setzen
    xticks(ax, linspace(options.posMin, options.posMax, options.nticks));
    ax.XAxis.TickLabelFormat = '%.2f'; % X-Achsentick-Format
    ax.XAxis.Exponent = 0; % Keine 10er-Potenzen
    set(ax, 'ytick', []); % Y-Achsenticks entfernen
    set(ax, 'yticklabel', []); % Y-Achsentick-Labels entfernen
    set(ax, 'YColor', 'none'); % Y-Achsenfarbe entfernen
    %set(ax, 'Color', 'none'); % Hintergrundfarbe entfernen
    set(ax, 'FontSize', options.imgScale * options.fontSize); % Schriftgröße setzen
    set(get(ax, 'Title'), 'FontSize', options.imgScale * (options.fontSize + 2)); % Titel-Schriftgröße setzen
    axis(ax, 'square'); % Achsenverhältnis beibehalten

    % Medianwert als Text einfügen
    hold(ax, 'on');
    text(ax, pos_err_median, 1.3 + max(pos_err_abs)/50, sprintf('$Med$ %.3f', pos_err_median), ...
        'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center', ...
        'Interpreter', 'latex', 'FontSize', options.imgScale * options.fontSize-1);
    hold(ax, 'off');
end
