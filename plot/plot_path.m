function fig = plot_path(path, anchor_pos_data, anchor_pos_data_type, ...
                         plane_height,skip_frames)
                     
    
    % evaluate cartesian position with decawave algorithm
    positions_decawave = perform_trilateration(path, anchor_pos_data,...
                         anchor_pos_data_type, @decawave_trilateration);
    
    % evaluate cartesian position with decawave algorithm
    positions_algebraic = perform_trilateration(path, anchor_pos_data,...
                         anchor_pos_data_type, @algebraic_trilateration);
    
    % evaluate cartesian position of the anchors
    anchor_positions = eval_anch_pos(anchor_pos_data, ...
                       anchor_pos_data_type);

    fig = figure;
    hold on
    % compare the position obtained using the two algorithms
    x = positions_decawave.x(skip_frames:end);
    y = positions_decawave.y(skip_frames:end);
    z = positions_decawave.z(skip_frames:end);
    scatter3(x, y, z + plane_height, 2);    

    x = positions_algebraic.x(skip_frames:end);
    y = positions_algebraic.y(skip_frames:end);
    z = positions_algebraic.z(skip_frames:end);
    scatter3(x, y, z + plane_height, 2);    
        
   % plot anchors positions
   for i=1:4
        x = anchor_positions(1,i);
        y = anchor_positions(2,i); 
        z = anchor_positions(3,i);
        plot3([x, x], [y, y], [0, z + plane_height], 'LineWidth', 10)
   end
   
   % plot ground
   [x, y] = meshgrid(xlim,ylim);
   z = zeros(length(ylim), length(xlim));
   surf(x, y, z, 'FaceAlpha',0.5, 'EdgeColor', 'none')
   
   % print legend
   legend('decawave', 'algebraic', 'a0', 'a1', 'a2', 'a3')
   
   xlabel('x (m)');
   ylabel('y (m)');
   zlabel('z (m)');
   
   Title = "Trilateration";
   
   if strcmp(anchor_pos_data_type, 'tag')
        Title = strcat(Title, ' (anchors position with tag over anchors)');
   elseif strcmp(anchor_pos_data_type, 'laser')
       Title = strcat(Title, '  (anchors position with manual measuraments)');
   elseif strcmp(anchor_pos_data_type, 'joined')
       Title = strcat(Title, ' (anchors position with autoranging procedures)');
   end
       
   title(Title);
end