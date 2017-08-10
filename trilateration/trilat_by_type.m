function trilat_by_type = trilat_by_type(path, anchor_pos_data, anchor_pos_data_type, storage)

    % storage contains trilateration results evaluated with different
    % anchor_pos_data_type 
    trilat_by_type = storage;

    % evaluate cartesian position with decawave algorithm
    trilat_by_type.(anchor_pos_data_type).('dw') =...
                    perform_trilateration(path, anchor_pos_data,...
                    anchor_pos_data_type, @decawave_trilateration);
    
    % evaluate cartesian position with decawave algorithm
    trilat_by_type.(anchor_pos_data_type).('algebraic') =...
                    perform_trilateration(path, anchor_pos_data,...
                    anchor_pos_data_type, @algebraic_trilateration);
                     
    % evaluate cartesian position with decawave algorithm
    trilat_by_type.(anchor_pos_data_type).('dw_cycle') =...
                    perform_trilateration(path, anchor_pos_data,...
                    anchor_pos_data_type, @decawave_cycle_trilateration);
end       