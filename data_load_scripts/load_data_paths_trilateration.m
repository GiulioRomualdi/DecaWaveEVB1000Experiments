function trilateration = load_data_paths_trilateration()

% get all files with the same postfix
files = dir('*_tpr.csv');

% init struct
trilateration = struct();
for file = files'
    % popolate struct
    trilateration = load_data_path_trilateration(file.name, trilateration);
end
end

function data = load_data_path_trilateration(filename, data)
% extract trilateration data from the data containing a test path
   
fprintf("Loading path data from %s.\n",filename);

% read data
data_from_file = readtable(filename);

% get tag_id
tag_id = strcat('tag_', num2str(data_from_file.('id')(1)));

% get tag position
x = data_from_file.('x');
y = data_from_file.('y');
z = data_from_file.('z');

% popolate struct
data.(tag_id).x = x;
data.(tag_id).y = y;
data.(tag_id).z = z;
end