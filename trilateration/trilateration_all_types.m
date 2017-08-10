function trilateration = trilateration_all_types(path, autoranging)

    % empty trilateration
    trilateration = struct();
    type_names = {'joined','tag','laser'};

    % cycle through type names
    for name = type_names
        trilateration = trilat_by_type(path, autoranging, name{:}, trilateration);
    end
    
end
