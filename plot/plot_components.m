function fig = plot_components(trilateration_data, types, ...
                               skip_frames)
    
    % create the figure                       
    fig = figure;
    
    coords = {'x', 'y', 'z'};
    
    for i = 1:length(types)
        for j = 1:length(coords)
            % plot each componentes
            subplot(length(types), length(coords), j + (i - 1) * length(coords));
            plot_component(trilateration_data, types{i}, ...
                               skip_frames, coords{j})
        end
    end
end

