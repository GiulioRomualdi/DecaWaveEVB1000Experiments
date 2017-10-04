function data = load_data_anch_autoranging(prefix, data)
    % extract autoranging ranges obtained using the novel procedure

    for i=0:2
        fprintf("Loading data of anchor %d.\n", i);
        data = load_data_from_file(strcat(prefix, num2str(i),'.csv'),data);
    end
end


function data = load_data_from_file(filename, data)
    data_from_file = readtable(filename);

    % the id of the anchor that produced this file
    % anchor_id = data_from_file.dest_id(1);

    % loop on each row
    for i=1:size(data_from_file,1)
    
        % extract flag
        % 'f' is for data evaluated after a final (anchor in normal mode)
        % 'r' is for data received from an anchor (anchorn in master mode)
        flag = char(data_from_file.flag(i));
    
        % extract source and destination ids
        % when flag is 'r' the destionation is the master
        % and the range is evaluated by the source anchor
        %
        % when flag is 'f' the source is the master
        % and the range is evaluated by the destination anchor
        src = data_from_file.src_id(i);
        dst = data_from_file.dest_id(i);
    
        % compare src and dst in order to skip
        % duplicate data
        if src > dst
            range = data_from_file.range(i);
            range_name = strcat('r',num2str(dst), num2str(src));
       
        
            if not(isfield(data,range_name))
                data.(range_name) = struct();
            end
       
            % check whether the range was evaluated by src or by dst
            evaluated_by_name = strcat('a', num2str(dst));
            if flag == 'r'
                evaluated_by_name = strcat('a', num2str(src)); 
            end
       
            if not(isfield(data.(range_name),evaluated_by_name))
                data.(range_name).(evaluated_by_name) = range;
            else
                old_list = data.(range_name).(evaluated_by_name);
                data.(range_name).(evaluated_by_name) = [old_list; range];
            end
        
            % while data is processed data with flag 'r' and 'f'
            % are glued together
            if not(isfield(data.(range_name),'joined'))
                data.(range_name).('joined') = range;
            else
                old_list = data.(range_name).('joined');
                data.(range_name).('joined') = [old_list; range];
            end
        end
    end
end