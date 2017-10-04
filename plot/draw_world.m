function fig = draw_world(anchor_positions_matrix, plane_height, Title)
    fig = figure;
    hold on
        
   % plot anchors positions
   for i=1:4
        x = anchor_positions_matrix(1,i);
        y = anchor_positions_matrix(2,i); 
        z = anchor_positions_matrix(3,i);
        plot3([x, x], [y, y], [0, z + plane_height], 'LineWidth', 10)
   end
   
   % plot ground
   offset = 1;
   x_lim = xlim;
   y_lim = ylim;
   
   x_lim(1) = x_lim(1) - offset;
   y_lim(1) = y_lim(1) - offset;
    
   x_lim(2) = x_lim(2) + offset;
   y_lim(2) = y_lim(2) + offset;
   
   [x, y] = meshgrid(x_lim, y_lim);
   z = zeros(length(ylim), length(xlim));
   surf(x, y, z, 'FaceAlpha',0.5, 'EdgeColor', 'none')
   
   % print Title, Legend and Labels
   plot_aesthetic(Title, '$x$ (m)', '$y$ (m)', '$z$ (m)', ...
                  'A0', 'A1', 'A2', 'A3', 'Ground')
end