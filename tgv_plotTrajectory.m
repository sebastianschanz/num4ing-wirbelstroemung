function tgv_plotTrajectory(ax, traj_X_pos, traj_Y_pos, X_pos, Y_pos)
    color1 = [0, 0.1, 0.6]; % Farbe für die Bahnlinie
    color2 = [1, 0.3, 0]; % Farbe für den Partikel
    
    % Plot Funktion für die Bahnlinie eines Partikels
    hold(ax, 'on'); % Halte den aktuellen Plot, um zusätzliche Daten hinzuzufügen
    
    % Bahnlinie in dünner roter Linie plotten
    h1 = plot(ax, traj_X_pos, traj_Y_pos, '-', 'Color', color1, 'LineWidth', 1.2); % Bahnlinie plotten
    
    % Position des Startpartikels als gefülltes Quadrat plotten
    plot(ax, X_pos, Y_pos, 's', 'MarkerFaceColor', 'none', 'MarkerEdgeColor', color1, 'MarkerSize', 10, 'LineWidth', 1); % Gefülltes Quadrat
    plot(ax, X_pos, Y_pos, 'o', 'MarkerFaceColor', color2, 'MarkerEdgeColor', color2, 'MarkerSize', 5); % Gefülltes Quadrat

    % Legende hinzufügen
    lgd = legend(ax, h1, 'Bahnlinie', 'Location', 'southeast', 'Interpreter', 'latex', 'FontSize', 10);
    
    % Boxrand der Legende entfernen
    lgd.EdgeColor = 'none';
    lgd.BoxFace.ColorType = 'truecoloralpha';
    lgd.BoxFace.ColorData = uint8([235; 235; 235; 255]); % leichtes Grau mit Transparenz
    lgd.ItemTokenSize = [10, 10]; % Markergröße in der Legende
    lgd.TextColor = 'black'; % Textfarbe beibehalten

    hold(ax, 'off'); % Halte den aktuellen Plot nicht länger
end
