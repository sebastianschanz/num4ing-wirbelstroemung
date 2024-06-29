function [ax1, ax2] = initPlots(X, Y, Psi, options)
    % Initialisierung der Plots
    figure;
    ax1 = subplot(1, 2, 1);  % Erstes Plotfenster
    plotData(ax1, X, Y, Psi, 'scatter', 'Lagrange Partikel', options);  % Partikelplot
    ax2 = subplot(1, 2, 2);  % Zweites Plotfenster
    plotData(ax2, X, Y, Psi, 'surf', 'Stromfunktion', options);  % Stromfunktionplot
end