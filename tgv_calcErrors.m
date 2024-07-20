function [pos_err_abs, Psi_err, Psi_mse_err] = tgv_calcErrors(X_pos, Y_pos, X_pos_a, Y_pos_a, Psi, Psi_a_now)
    % Calculates the absolute positional errors between analytical and numerical solution 
    % as well as the standard devation for boxplotting and the error of the respective stream functions

    pos_err_x = X_pos - X_pos_a;
    pos_err_y = Y_pos - Y_pos_a;
    pos_err_abs = sqrt(pos_err_x.^2 + pos_err_y.^2); % Absolute Fehler der Partikelpositionen berechnen

    % Calculate the error of stream functions
    Psi_err = Psi - Psi_a_now;
    Psi_mse_err = mean(Psi_err(:).^2);
end