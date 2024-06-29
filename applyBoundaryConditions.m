function F = applyBoundaryConditions(F, type)
    if nargin < 2
        type = 'Dirichlet';
    end
    
    switch type
        case 'Dirichlet'
            F(1, :) = 0;      % unterer Rand
            F(end, :) = 0;    % oberer Rand
            F(:, 1) = 0;      % linker Rand
            F(:, end) = 0;    % rechter Rand
        case 'Neumann'
            F(1, 2:end-1) = F(2, 2:end-1);      % unterer Rand
            F(end, 2:end-1) = F(end-1, 2:end-1); % oberer Rand
            F(2:end-1, 1) = F(2:end-1, 2);      % linker Rand
            F(2:end-1, end) = F(2:end-1, end-1); % rechter Rand
    end
end