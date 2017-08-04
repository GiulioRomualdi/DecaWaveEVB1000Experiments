% process anchor to anchor data

% data obtained using autoranging
a2a = load_data_anch('a2a_anch_');

% data obtained using tag over anchor procedure
tag2a = load_data_tag('a2a_tag_');

% data obtained with manual measurements
laser = laser_data();

% put all the data into a struct
autoranging = merge_data(a2a, tag2a, laser);

clear a2a tag2a laser;

save autoranging autoranging;