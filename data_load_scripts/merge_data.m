function out = merge_data(a2a, tag2a, laser)

% copy data into the output
out = a2a;

% get the fields
fields = fieldnames(out);

% merge data
for i = 1:size(fields)
    out.(char(fields(i))).('tag') = tag2a.(char(fields(i))).('tag');
    out.(char(fields(i))).('laser') = laser.(char(fields(i))).('laser');
end
end