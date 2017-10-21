function trilat_by_type = trilat_by_type(path, anchor_position)

% storage contains trilateration results evaluated with different
% anchor_pos_data_type 
trilat_by_type = struct();

% evaluate cartesian position with decawave algorithm
trilat_by_type.('dw') = perform_trilateration(path, anchor_position,...
                                              @decawave_trilateration);
    
% evaluate cartesian position with decawave algorithm
trilat_by_type.('algebraic') = perform_trilateration(path, anchor_position,...
                                                @algebraic_trilateration);
                     
% evaluate cartesian position with decawave algorithm
trilat_by_type.('dw_cycle') = perform_trilateration(path, anchor_position,...
                                          @decawave_cycle_trilateration);
end       