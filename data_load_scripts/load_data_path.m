function out = load_data_path(filename)
    % extract ranges from the data containing a test path
    
    fprintf("Loading path data.\n");

    out = struct();
    
    data_from_file = readtable(filename);
    
    for i=1:size(data_from_file,1)
        found_zero_entry = 0;

        for j=0:3
            % generate name for struct (range_name)
            range_name = strcat('r',num2str(j));
            
            % extract the range
            ranges = data_from_file.(range_name);
            range = ranges(i);
            
            % if a 0 range is found (missing data from the serial line)
            % the entire line is discarded
            if(range == 0)
                found_zero_entry = 1;
                break;
            end
        end
       
        % skip line if 0 entries found
        if (found_zero_entry)
            continue;
        end
        
        for j=0:3
            
            % generate name for struct (range_name)
            range_name = strcat('r',num2str(j));
                
            % extract the range
            ranges = data_from_file.(range_name);
            range = ranges(i) / 1000;
                
            % save the range
            if not(isfield(out,range_name))
                out.(range_name) = range;
            else
                out.(range_name) = [out.(range_name); range];
            end
        end  
    end
end