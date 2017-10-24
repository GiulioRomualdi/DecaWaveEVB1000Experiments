function data = load_data_tag_autoranging(prefix, data)
    % extract autoranging ranges obtained using the 'tag_over_anchor' procedure
    for i=0:2
        fprintf('Loading data of tag over anchor %d.\n', i);
        data = load_data_from_file(strcat(prefix,num2str(i),'.csv'),i, data);
    end

    % concat structures
end

function data = load_data_from_file(filename, origin,data)
    file_data = readtable(filename);
        
    for i=1:size(file_data,1)
        for j=0:3
            % avoid saving duplicated data
            if (j > origin)
                % generate name for struct (range_name)
                range_name = strcat('r',num2str(origin),num2str(j));
                
                % generate name as found in the csv (range_name_short)
                range_name_short = strcat('r',num2str(j));
                
                % extract the range
                ranges = file_data.(range_name_short);
                range = nonzeros(ranges(i) / 1000);
                
                % save the range
                if not(isfield(data,range_name))
                    data.(range_name).('tag') = range;
                % data.(range_name) can already exist however 
                % data.(range_name).tag does not!
                elseif not(isfield(data.(range_name),'tag'))
                    data.(range_name).('tag') = range;
                else
                    data.(range_name).('tag') = [data.(range_name).('tag'); range];
                end
            end
        end
    end
end
