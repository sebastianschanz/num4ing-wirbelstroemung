function F = tgv_applyBC(F, boundary_type)
    if strcmp(boundary_type, 'periodic')
        F(:, 1) = F(:, end-1);
        F(:, end) = F(:, 2);
        F(1, :) = F(end-1, :);
        F(end, :) = F(2, :);
    elseif strcmp(boundary_type, 'dirichlet')
        F(:, 1) = 0;
        F(:, end) = 0;
        F(1, :) = 0;
        F(end, :) = 0;
    elseif strcmp(boundary_type, 'neumann')
        F(:, 1) = F(:, 2);
        F(:, end) = F(:, end-1);
        F(1, :) = F(2, :);
        F(end, :) = F(end-1, :);
    end
end
