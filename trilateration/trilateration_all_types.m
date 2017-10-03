function trilateration = trilateration_all_types(path, anchor_position)

    % empty trilateration
    trilateration = struct();
    types = fieldnames(anchor_position)';
    % cycle through type names
    for type = types
        trilateration.(type{:}) = trilat_by_type(path, anchor_position.(type{:}));
    end
    
end
