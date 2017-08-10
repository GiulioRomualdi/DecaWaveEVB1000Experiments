plot_path(trilateration.laser, autoranging, 'laser', plane_height, 1);
plot_path(trilateration.tag, autoranging, 'tag', plane_height, 1);
plot_path(trilateration.joined, autoranging, 'joined', plane_height, 1);

plot_a2a_histograms(autoranging);