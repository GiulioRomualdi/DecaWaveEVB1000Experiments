function plot_component(signal, skip_frames, Title, component, Legend)
               
hold on

% plot the signal
signal = signal(skip_frames:end);
plot(signal);
   
% set the Title, the labels and the legend
plot_aesthetic(Title, 'samples', strcat('$',component,'$ (m)'),'', Legend);   
end