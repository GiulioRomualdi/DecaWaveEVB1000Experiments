function trilateration = decawave_cycle_trilateration(ranges, anch_pos)
%DECAWAVE_CYCLE_TRILATERATION evaluate decawave_cycle_trilateration
%
% trilateration = DECAWAVE_CYCLE_TRILATERATION(ranges, anch_pos) calculate
%                 trilateration using decawave cycle procedure
% 
%       *   ranges is a column vector with the ranges between the tag and 
%           the anchors (i.e. [r0; r1; r2; r3] where ri is the 
%           ranges between the tag and the i-th anchor
%       *   anch_pos is the matrix of the anchors positions 
%           (i.e. [a0.x a1.x a2.x a3.x
%                  a0.y a1.y a2.y a3.y
%                  a0.z a1.z a2.z a3.z])
%
%      returns an array with the position of the Tag in meters

    % ranges are converted in mm
    ranges_mm = ranges * 1000;
    
    % trasform the matrix anch_pos in a row vector
    anch_pos_vector = reshape(anch_pos,[1, 12]);
    
    use4thAnchor = 1;
    
    % perform trilateration
    trilateration = zeros(1,3);
    for i=0:3
        shifted_ranges = circshift(ranges_mm, -1 * i);
        ranges_cell = num2cell(shifted_ranges);
        
        shifted_anch_pos = circshift(anch_pos_vector, -3 * i);

        [trilat, res, ~] = decatrilat(use4thAnchor, ranges_cell{:}, ...
                             shifted_anch_pos, 0);
        if(res(1) < 0)
            trilateration = NaN * ones(1,3);
            return;
        end
        trilateration = trilateration + trilat(1:3);
    end
    
    trilateration = trilateration / 4;
end