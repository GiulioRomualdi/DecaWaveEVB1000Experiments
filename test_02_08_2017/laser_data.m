function [a2a_manual_meas, plane_height] = laser_data()

    plane_height = 1.653;
    
    a2a_manual_meas = struct();
    a2a_manual_meas.('r01').('laser') = 1.983;
    a2a_manual_meas.('r02').('laser') = 5.470;
    a2a_manual_meas.('r03').('laser') = 3.835;
    a2a_manual_meas.('r12').('laser') = 4.393;
    a2a_manual_meas.('r13').('laser') = 4.280;
    a2a_manual_meas.('r23').('laser') = 3.669;
end