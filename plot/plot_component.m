function plot_component(signal, skip_frames, Title, component, Legend)
% PLOT_COMPONENT plot a signal
%   PLOT_COMPONENT(signal, skip_frames, Title, component, Legend) plot a
%   signal in a already existing figure
%   * signal: vector of the signal that will be plotted;
%   * skip_frames: number of frame that will be skipped in the plot;
%   * Title: title of the plot;
%   * skip_frames: string of the component (i.e. 'x', 'y' or 'z');
%   * Legend: legend associated to the plot.

hold on

% plot the signal
signal = signal(skip_frames:end);
plot(signal);
   
% set the Title, the labels and the legend
plot_aesthetic(Title, 'samples', strcat('$',component,'$ (m)'),'', Legend);   
end