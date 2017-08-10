function trilateration = algebraic_trilateration(ranges, anch_pos)
%ALGEBRAIC_TRILATERATION evaluate algebric_trilateration
%
% trilateration = ALGEBRAIC_TRILATERATION(ranges, anch_pos) calculate
%                 trilateration using algebric procedure
% 
%       *   ranges (in m) is a column vector with the ranges  between 
%           the tag and the anchors (i.e. [r0; r1; r2; r3] where ri is the 
%           ranges between the tag and the i-th anchor)
%       *   anch_pos is the matrix of the anchors positions 
%           (i.e. [a0.x a1.x a2.x a3.x
%                  a0.y a1.y a2.y a3.y
%                  a0.z a1.z a2.z a3.z])
%
%      returns an array with the cartesian position of the Tag in meters

    % ranges are converted in mm
    ranges_cell = num2cell(1000 * ranges);

    % trasform the matrix anch_pos in a row vector
    anch_pos_vector = reshape(anch_pos,[1, 12]);

    % perform trilateration
    use4thAnchor = 1;
    [trilat, ~, ~] = decatrilat(use4thAnchor, ranges_cell{:}, ...
                             anch_pos_vector, 0);

    trilateration = trilat(4:6) * 10^-3;
end