function [data, plane_height] = laser_data(data)
    plane_height = 1.875;
    anchor3_height = 2.75;
    
    delta_h = anchor3_height - plane_height;
    data.('r01').('laser') = 17.67;
    data.('r02').('laser') = 11.80;
    data.('r03').('laser') = sqrt(delta_h^2 + 9^2);
    data.('r12').('laser') = 16.94;
    data.('r13').('laser') = sqrt(delta_h^2 + 10.83^2);
    data.('r23').('laser') = sqrt(delta_h^2 + 7.17^2);
end