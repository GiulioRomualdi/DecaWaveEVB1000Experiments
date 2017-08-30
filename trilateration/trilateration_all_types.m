function trilateration = trilateration_all_types(path, autoranging)

    % empty trilateration
    trilateration = struct();

    if(isfield(autoranging.r01,'tag'))
        type_names = {'joined','tag','laser'};
    else
        type_names = {'joined','laser'};
    end
    
    % cycle through type names
    for name = type_names
        trilateration = trilat_by_type(path, autoranging, name{:}, trilateration);
    end
    
end
