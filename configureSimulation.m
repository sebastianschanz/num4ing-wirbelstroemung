function options = configureSimulation()
    options = struct('nu', 0.01, 't_end', 5, 't_nr', 100, 'x_nr', 100, 'y_nr', 100, 'method', 'expliziter-euler', 'colormap', 'parula');
end