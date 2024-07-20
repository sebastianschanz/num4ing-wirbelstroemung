function tgv_writeErrors(ax, X_error, Y_error, mse_error_Psi, titleText)
    cla(ax); % Clear the current plot in the specified axis
    % Display the MSE of Psi
    text(0, 0.7, ['MSE of $\Psi$: ', num2str(mse_error_Psi)], ...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle', 'Interpreter', 'latex', 'FontSize', 10);
    % Display the X error
    text(0, 0.5, ['X Error: ', num2str(X_error)], ...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle', 'Interpreter', 'latex', 'FontSize', 10);
    % Display the Y error
    text(0, 0.3, ['Y Error: ', num2str(Y_error)], ...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle', 'Interpreter', 'latex', 'FontSize', 10);
    % Set the title
    title(ax, titleText, 'Interpreter', 'latex', 'FontSize', 12);
    % Turn off the axis
    axis(ax, 'off');
end
