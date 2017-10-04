function plot_path(x, y, z, plane_height, skip_frames, Legend)
% PLOT_PATH plot a 3D path
%   PLOT_PATH(x, y, z, plane_height, skip_frames, Title, Legend)
%   * x, y and z are three vector contating the x, y and z coordinates in
%     meteres of the path
%   * plane_height reppresents the height of the common plane between A0,
%     A1 and A2
%   * skip_frames reppresents the number of frame that has to be skipped in
%     the reppresentation
%   * Title and Legend are two strings with the Title and the Legend of
%     plot

hold on
        
% cut signals according to skip_frames
x = x(skip_frames:end);
y = y(skip_frames:end);
z = z(skip_frames:end);
      
% make plot
scatter3(x, y, z + plane_height, 2);    
    
% print legend
plot_aesthetic('','','','', Legend);
end