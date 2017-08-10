function fig = plot_path(trilateration_data, anchor_pos_data, anchor_pos_data_type, ...
                         plane_height, skip_frames)
                     
    % evaluate cartesian position of the anchors
    anchor_positions = eval_anch_pos(anchor_pos_data, ...
                       anchor_pos_data_type);

    fig = figure;
    hold on
    
    % extract algorithm name from trilateration_data
    alg_names = fieldnames(trilateration_data)';
    
    % cycle over algorithms
    for alg_name = alg_names
        
        % extract trilateration data
        positions = trilateration_data.(alg_name{:});
        
        % cut signals according to skip_frames
         x = positions.x(skip_frames:end);
         y = positions.y(skip_frames:end);
         z = positions.z(skip_frames:end);
         
         % make plot
         scatter3(x, y, z + plane_height, 2);    
    end
        
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
   legend(alg_names{:}, 'a0', 'a1', 'a2', 'a3')
   
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