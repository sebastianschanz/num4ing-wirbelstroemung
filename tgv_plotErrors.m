function pos_err_std = tgv_plotErrors(ax, pos_err_abs, titleText, options)
    % Function to create a box plot of absolute position errors

    color = [255, 51, 0]/255; % Color for the box plot
    % This function plots the particle position errors in a horizontal box chart
    cla(ax); % Clear current plot

    % Calculate error values
    pos_err_abs = pos_err_abs(:); % Convert error vector to column vector
    pos_err_std = std(pos_err_abs); % Standard deviation of error values
    pos_err_median = median(pos_err_abs); % Median of error values
    
    % Create the box plot
    boxchart(ax, pos_err_abs, 'Orientation', 'horizontal', 'BoxFaceColor', color, 'MarkerColor', color, 'MarkerSize', options.imgScale * 4); % Plot box plot in red color
    title(ax, titleText, 'Interpreter', 'latex'); % Set title
    xlim(ax, [0, 0.1]); % Limit x-axis from 0 to the specified value
    xticks(ax, linspace(0, 0.1, options.nticks));
    ax.XAxis.TickLabelFormat = '%.2f'; % Set x-axis tick label format
    ax.XAxis.Exponent = 0; % Set x-axis exponent to 0
    set(ax, 'ytick', []); % Remove y-axis ticks
    set(ax, 'yticklabel', []); % Remove y-axis labels
    set(ax, 'YColor', 'none'); % Remove y-axis line
    set(ax, 'Color', 'none'); % Remove background
    set(ax, 'FontSize', options.imgScale * options.fontSize); % Set font size
    set(get(ax, 'Title'), 'FontSize', options.imgScale * (options.fontSize + 2)); % Set title font size
    axis(ax, 'square'); % Achsenverhältnis beibehalten

    % Add an annotation at the median line
    hold(ax, 'on');
    text(ax, pos_err_median, 1.3 + max(pos_err_abs)/50, sprintf('$Med$ %.3f', pos_err_median), ...
        'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center', ...
        'Interpreter', 'latex', 'FontSize', options.imgScale * options.fontSize);
    hold(ax, 'off');
end
