function [data, plane_height] = laser_data(data)
    plane_height = 1.89;
    
    data.('r01').('laser') = 3.068;
    data.('r02').('laser') = 2.313;
    data.('r03').('laser') = 3.755;
    data.('r12').('laser') = 4.022;
    data.('r13').('laser') = 2.891;
    data.('r23').('laser') = 2.654;
end
