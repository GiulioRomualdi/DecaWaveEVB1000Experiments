function out = laser_data()
    out = struct();
    delta_h = 2.75-1.875;
    out.('r01').('laser') = 17.67;
    out.('r02').('laser') = 11.80;
    out.('r03').('laser') = sqrt(delta_h^2 + 9^2);
    out.('r12').('laser') = 16.94;
    out.('r13').('laser') = sqrt(delta_h^2 + 10.83^2);
    out.('r23').('laser') = sqrt(delta_h^2 + 7.17^2);
end