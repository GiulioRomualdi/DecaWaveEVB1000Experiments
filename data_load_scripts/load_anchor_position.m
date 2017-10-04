function anchor_position = load_anchor_position(postfix)
% get all files with the same postfix
files = dir(strcat('*', postfix));

filename = files(1).name;

% read data
data_from_file = readtable(filename);

% get anchors position
% A0
a0_x = data_from_file.('a0_x')(1);
a0_y = data_from_file.('a0_y')(1);
a0_z = data_from_file.('a0_z')(1);

% A1
a1_x = data_from_file.('a1_x')(1);
a1_y = data_from_file.('a1_y')(1);
a1_z = data_from_file.('a1_z')(1);

% A2
a2_x = data_from_file.('a2_x')(1);
a2_y = data_from_file.('a2_y')(1);
a2_z = data_from_file.('a2_z')(1);

% A3
a3_x = data_from_file.('a3_x')(1);
a3_y = data_from_file.('a3_y')(1);
a3_z = data_from_file.('a3_z')(1);

% popolate matrix
anchor_position = [a0_x, a1_x, a2_x, a3_x;
                   a0_y, a1_y, a2_y, a3_y;
                   a0_z, a1_z, a2_z, a3_z];

end