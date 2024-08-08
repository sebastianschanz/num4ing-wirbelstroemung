function [pos_err_abs, Psi_err, Psi_mse_err] = tgv_calcErrors(X_n, Y_n, X_a, Y_a, Psi_n_now, Psi_a_now)
    % Berechnet den absoluten Fehler der Partikelpositionen, den Fehler der Stromfunktionen und die Enstrophie

    % Absolute Fehler der Partikelpositionen berechnen
    pos_err_x = X_n - X_a;
    pos_err_y = Y_n - Y_a;
    pos_err_abs = sqrt(pos_err_x.^2 + pos_err_y.^2);

    % Summe der Fehlerquadrate der Stromfunktion berechnen
    Psi_err = Psi_n_now - Psi_a_now;
    Psi_mse_err = mean(Psi_err(:).^2);
end