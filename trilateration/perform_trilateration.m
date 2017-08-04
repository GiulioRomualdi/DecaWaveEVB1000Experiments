function positions = perform_trilateration(path, anchor_pos_data,...
    anchor_pos_data_type, trilat_alg)
    % perform trilateration on a set of ranges given
    % the anchor to anchor data,
    % the type of the anchor to anchor data (e.g. autoranging or tag_over_anchor)
    % and a trilateration algorithm
    
    % array containing resulting positions
    positions_array = [];
    
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
       positions_array = [positions_array; position];
    end
    
    % returns positions in a struct
    positions = struct();
    positions.('x') = positions_array(:,1);
    positions.('y') = positions_array(:,2);
    positions.('z') = positions_array(:,3);
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