function out = load_data_tag(prefix)
    % extract autoranging ranges obtained using the 'tag_over_anchor' procedure

    data = struct();
    for i=0:2
        fprintf("Loading data of tag over anchor %d.\n", i);
        data.(strcat('data',num2str(i))) = load_data_from_file(strcat(prefix,num2str(i),'.csv'),i);
    end

    % concat structures
    out = cell2struct(...
        cat(1,struct2cell(data.data0), struct2cell(data.data1), struct2cell(data.data2)),...
        cat(1,fieldnames(data.data0), fieldnames(data.data1), fieldnames(data.data2)),...
        1);
end

function out = load_data_from_file(filename, origin)
    file_data = readtable(filename);
    
    out = struct();
    
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
                if not(isfield(out,range_name))
                    out.(range_name).('tag') = range;
                else
                    out.(range_name).('tag') = [out.(range_name).('tag'); range];
                end
            end

        end
    end
end