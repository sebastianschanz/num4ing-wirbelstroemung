options = struct;
options.nu = 0.01; % Viscosity
options.t_end = 5; % End time
options.t_nr = 100; % Number of time steps
options.x_nr = 100; % Number of x grid points
options.y_nr = 100; % Number of y grid points

% Analytische Lösung des Taylor-Green-Wirbels
Taylor_Green_Wirbel_Sim(options)

function [U, V] = Taylor_Green_Wirbel_Sim(options)
    
    % Gitter (Grid)
    x     = linspace(0, 2*pi, options.x_nr);
    y     = linspace(0, 2*pi, options.y_nr);
    [X,Y] = meshgrid(x, y);
    
    % Lösung (Solution)
    U     = @(t) sin(X) .* cos(Y) .* exp(-2 * options.nu * t);
    V     = @(t) -cos(X) .* sin(Y) .* exp(-2 * options.nu * t);
    Psi   = @(t) sin(X).*sin(Y).*exp(-2*options.nu*t);
    
    % Lagrange Partikel
    subplot(1,2,1);
    X_pos = X;
    Y_pos = Y;
    sctr  = scatter(X_pos',Y_pos','filled');
    xlim([0 2*pi]);
    ylim([0 2*pi]);
    title('Lagrange Partikel');
    xlabel('$x$','Interpreter','latex');
    ylabel('$y$','Interpreter','latex');
    
    % Stromfunktion
    subplot(1,2,2);
    cont = surfc(X,Y,Psi(0));
    xlim([0 2*pi]);
    ylim([0 2*pi]);
    zlim([-1 1]);
    title('Stromfunktion');
    xlabel('$x$','Interpreter','latex');
    ylabel('$y$','Interpreter','latex');
    zlabel('$\Psi$','Interpreter','latex');
    
    % Zeitschleife
    time  = linspace(0,options.t_end,options.t_nr);
    t_stp = time(2)-time(1);
    for t = time
    
        % Aktuelle Strömungsgrößen
        U_now   = U(t);
        V_now   = V(t);
        Psi_now = Psi(t);
        
        % Plot
        for row = 1:options.y_nr
            sctr(row).XData = X_pos(row,:);
            sctr(row).YData = Y_pos(row,:);
        end
        cont(1).ZData = Psi_now;
        cont(2).ZData = Psi_now;
        sgtitle([ ...
            '$\nu=' num2str(options.nu) ...
            ',~t=' num2str(t,'%.2f') '$'],'Interpreter','latex');
        drawnow;
        
        % Nächster Zeitschritt
        X_pos = X_pos + t_stp*interp2(X,Y,U_now,X_pos,Y_pos);
        Y_pos = Y_pos + t_stp*interp2(X,Y,V_now,X_pos,Y_pos);
    
    end
end
    