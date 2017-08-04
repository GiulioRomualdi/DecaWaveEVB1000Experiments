function positions = perform_trilateration(path, anchor_pos_data,...
    anchor_pos_data_type, trilat_alg)
    % perform trilateration on a set of ranges given
    % the anchor to anchor data,
    % the type of the anchor to anchor data (e.g. autoranging or tag_over_anchor)
    % and a trilateration algorithm
    
    % array containing resulting positions
    positions = [];
    
    % extract path size using the first column
    path_length = length(path.r0);
    
    % eval anchor positions using anchor_to_anchor data
    anchor_positions = eval_anch_pos(anchor_pos_data, anchor_pos_data_type);
    
    % cycle over ranges
    for i=1:path_length
        
       % extract vector containing ranges 
       ranges = path_row_to_vector(path, i);
       
       % perform trilateration on the ranges extracted
       position = trilat_alg(ranges, anchor_positions);
       
       % append position
       positions = [positions; position];
    end
    
end

function ranges = path_row_to_vector(path, row_index)
    % extract field names
    range_names = fields(path);
    
    ranges = [];
    
    % cycle over range names
    for i=1:length(range_names)
        
        % extract field name
        range_name = char(range_names(i));
        
        % extract column (i.e. r_i)
        range_column = path.(range_name);
        
        % append range
        ranges = [ranges; range_column(row_index)];
    end
end

function anchor_positions = eval_anch_pos(anchor_to_anchor_data, data_type)

    % extract the anchor positions from an anchor_to_anchor_data struct
    % given the type of anchor_to_anchor_data
    %
    % i.e. 'tag' indicates data collected using the 'tag_over_anchor'
    % procecure
    %      'joined' indicates data collected using the novel autoranging
    %      procedure
    
    % array containing the means of the ranges
    means = [];
    
    range_names = fieldnames(anchor_to_anchor_data);

    % cycle through all the ranges and evaluate the means
    for i = 1:length(range_names)
        % extract range name (i.e. r_ij)
        range_name = char(field_names(i));
        
        % eval mean for each range field
        mean_value = mean(data.(range_name).(data_type));
        
        % append data
        means = [means; mean_value];
    end
    
    % evaluate anchors cartesian position using the means
    [a0, a1, a2, a3] = rangesToPos(means);
    anchor_positions = [a0, a1, a2, a3];
end

function [ A0_, A1_, A2_, A3_] = rangesToPos( R_mis )
% RANGESTOPOS Returns the coordinates of points, elaborating the
% mean ranges, given as input.

    r01 = R_mis(1);
    r02 = R_mis(2);
    r03 = R_mis(3);
    r12 = R_mis(4);
    r13 = R_mis(5);
    r23 = R_mis(6);
    
    % angle [rad] between r01 and r02.
    % condition C is to verify that the ranges among A0 A1 A2 form a
    % triangle. Otherwise CARNOT FORMULA cannot be used to obtain the angles
    % and the estimated coordinates, corresponding to this set of ranges, are set to 0.
    % In this case discard the result.
    C = (r01^2+r02^2-r12^2)/(2*r01*r02);
    alpha = acos((r01^2+r02^2-r12^2)/(2*r01*r02));
    
    % angle [rad] between r01 and r12
    beta = acos((r01^2+r12^2-r02^2)/(2*r01*r12));
    
    % angle [rad] between r02 and r12
    gamma = acos((r02^2+r12^2-r01^2)/(2*r02*r12));
    
    % Assuming ANCHOR0 as the origin of the coordinate system A0 = [0 0 0]
    % and ANCHOR1 along (positive) Y axis, the Y axis direction is given by the
    % line passing through A0 and A1. As A0, A1, A2 must be placed at the same
    % height from the ground, A2 can be computed.
    if abs(C)<= 1
        A0 = [0 0 0]';
        A1 = [0 r01 0]';
        A2 = [r02*sin(alpha) r02*cos(alpha) 0]';
        
        % A3 COMPUTATION [x3 y3 z3]';
        syms y3
        x3 = (A2(1)^2-r23^2+(y3-A2(2))^2+r03^2-y3^2)/(2*A2(1));
        z3_2 = r03^2-x3^2-y3^2; % z3_2 is z3 squared
        eqn = sqrt(x3^2+(y3-A1(2))^2+z3_2)==r13;
        solY = solve(eqn, y3);
        solX = (A2(1)^2-r23^2+(solY-A2(2))^2+r03^2-solY^2)/(2*A2(1));
        solY;
        solZ = sqrt(r03^2-solX^2-solY^2);
        
        A0_= A0;
        A1_= A1;
        A2_= A2;
        A3_ = [double(solX) double(solY) double(solZ)]';
        C;
    else
        A0_=[0 0 0];
        A1_=[0 0 0];
        A2_=[0 0 0];
        A3_=[0 0 0];
    end

end

% function out = perform_trilateration()
%     ffoo(@foo)
%     ffoo(@foo1)
% 
% end
% 
% function out = ffoo(fun)
%     out = fun();
% end
% 
% function out = foo
%     out = 1;
% end
% 
% function out = foo1
%     out = 2;
% end
