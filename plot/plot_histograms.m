function plot_histograms(data)
% extract fieldnames
fields = fieldnames(data);

for i=1:size(fields)
    subplot(3,2,i);
    field = char(fields(i));
    plot_histogram(field, data.(field), 1024);
end 
end

function plot_histogram(experiment_name, data, max_size)
% extract fieldnames
fields = fieldnames(data);

% evaluate the min and the max value of the two distribution
min_value = inf;
max_value = -inf;

for i = 1:size(fields)
    d = data.(char(fields(i)));
    
    if length(d) > max_size
        d = d(1:max_size);
    end
    
    new_min = min(d);
    new_max = max(d);
    
    if new_min < min_value
        min_value = new_min;
    end
    if new_max > max_value
        max_value = new_max;
    end
end

% generate support vector for the histogram
resolution = 0.005;
support = min_value : resolution : max_value;

% plot the histograms
hold on
for i = 1:size(fields)
    field_name = char(fields(i));
    d = data.(field_name);
%     if not(strcmp(field_name,'laser'))
%         histogram(d, support);
%     end

    if length(d) > max_size
        d = d(1:max_size);
    end
    
    if strcmp(field_name,'joined')
         histogram(d, support,'FaceColor', [0 0.5 0.5]);
    elseif strcmp(field_name, 'tag')
         histogram(d, support,'FaceColor', [0.5 0 0]);
    end
end

% plot laser value
y_lim = ylim;
line([data.('laser'), data.('laser')],[0, y_lim(2)],'Color','blue','LineStyle','--')

% legend
legend('anch','tag','laser');

% labels
xlabel('Range (m)');
ylabel('#');

% title 
title(experiment_name)

end