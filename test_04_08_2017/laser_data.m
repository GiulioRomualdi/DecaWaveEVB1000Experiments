function [a2a_manual_meas, plane_height] = laser_data()

    a2a_manual_meas = struct();
    
    plane_height = 1.748;
    anchor3_height = 2.190;
    
    a2a_manual_meas.('r01').('laser') = 2.444;
    a2a_manual_meas.('r02').('laser') = 6.636;
    a2a_manual_meas.('r03').('laser') = 5.258;
    a2a_manual_meas.('r12').('laser') = 5.915;
    a2a_manual_meas.('r13').('laser') = 5.648;
    a2a_manual_meas.('r23').('laser') = 2.768;
end
