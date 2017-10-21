function plot_a2a_histograms(autoranging)
% extract fieldnames
fields = fieldnames(autoranging);

% open a new figure
figure();

for i=1:size(fields)
    subplot(3,2,i);
    field = char(fields(i));
    % plot histograms
    plot_histogram(autoranging.(field), inf);
    
    % plot laser measurement 
    plot_data_laser(autoranging.(field));

    % generate the legend
    Legend = fieldnames(autoranging.(field))';
    Legend = intersect(Legend, {'joined','tag','laser'});

    % add title, legend and label
    plot_aesthetic(field, 'Range (m)', 'Samples', '', Legend{:})
end 
end

function plot_data_laser(data)
if (isfield(data,'laser')) 
    % plot laser value
    y_lim = ylim;
    line([data.('laser'), data.('laser')],[0, y_lim(2)],'Color','red','LineStyle','--')
end
end


function plot_histogram(data, max_size)
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

    if length(d) > max_size
        d = d(1:max_size);
    end
    
    if strcmp(field_name,'joined')
         histogram(d, support)%,'FaceColor', [0 0.5 0.5]);
    elseif strcmp(field_name, 'tag')
         histogram(d, support)%,'FaceColor', [0.5 0 0]);
    end
end
end