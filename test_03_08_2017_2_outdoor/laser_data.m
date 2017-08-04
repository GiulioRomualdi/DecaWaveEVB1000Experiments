function [a2a_manual_meas, plane_height] = laser_data()

    a2a_manual_meas = struct();
    
    plane_height = 1.875;
    anchor3_height = 2.75;
    
    delta_h = anchor3_height - plane_height;
    a2a_manual_meas.('r01').('laser') = 17.67;
    a2a_manual_meas.('r02').('laser') = 11.80;
    a2a_manual_meas.('r03').('laser') = sqrt(delta_h^2 + 9^2);
    a2a_manual_meas.('r12').('laser') = 16.94;
    a2a_manual_meas.('r13').('laser') = sqrt(delta_h^2 + 10.83^2);
    a2a_manual_meas.('r23').('laser') = sqrt(delta_h^2 + 7.17^2);
end