function plot_component(trilateration_data, anchor_pos_data_type, ...
                               skip_frames, component)
                     
    hold on
    
    % extract algorithm name from trilateration_data
    alg_names = fieldnames(trilateration_data.(anchor_pos_data_type))';
    
    % cycle over algorithms
    for alg_name = alg_names
        
        % extract trilateration data
        positions = trilateration_data.(anchor_pos_data_type).(alg_name{:});
        
        % cut signals according to skip_frames
        signal = positions.(component);
        signal = signal(skip_frames:end);
        
        % make plot
        plot(signal);    
    end
        
   
   % print legend
   legend(alg_names{:})
   
   xlabel('samples');
   ylabel(strcat(component,' (m)'));
   
   % print title
   Title = "Trilateration";
   
   if strcmp(anchor_pos_data_type, 'tag')
        Title = strcat(Title, ' (anchors position with tag over anchors)');
   elseif strcmp(anchor_pos_data_type, 'laser')
       Title = strcat(Title, '  (anchors position with manual measurements)');
   elseif strcmp(anchor_pos_data_type, 'joined')
       Title = strcat(Title, ' (anchors position with autoranging procedures)');
   end
    
   title(Title);
   
   % set grid
   grid on;
end