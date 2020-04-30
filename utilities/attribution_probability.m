function [T_attributed,T_not_attributed] = attribution_probability(cmap,nodes_human,metadata_fh)
    
    animal_sources = metadata_fh(:,2);
    animal_sources(nodes_human) = [];
    animal_sources_unique = unique(animal_sources);
    nodes_animal_sources = cell(length(animal_sources_unique),1);
    for i=1:length(animal_sources_unique)
        nodes_animal_sources{i} = find(strcmp(animal_sources,animal_sources_unique{i}));
    end

    cmh_prob = cmap(nodes_human,:);               
    cmh_prob(:,nodes_human) = 0;                   
    human_ID = metadata_fh(nodes_human,1);

    sum_rows_cmh = sum(cmh_prob,2);
    non_attributed_human = find(~sum_rows_cmh);
    non_attributed_human_ID = human_ID(non_attributed_human);

    cmh_prob(non_attributed_human,:) = []; 
    attributed_human_ID = human_ID;
    attributed_human_ID(non_attributed_human) = [];

    [r_cmhp,~] = size(cmh_prob);

    P = zeros(r_cmhp,length(animal_sources_unique));
    for i=1:r_cmhp
        for j=1:length(animal_sources_unique)
            P(i,j) = (sum(cmh_prob(i,nodes_animal_sources{j}))./sum(cmh_prob(i,:))).*100;
        end
    end
    
    T_not_attributed = cell2table(non_attributed_human_ID);
    T_not_attributed.Properties.VariableNames = {'Sample ID'};

    [rP,cP] = size(P);
    table_size = [rP,cP];
    varTypes = cell(1,cP);
    for i=1:cP
        varTypes{i} = 'double';
    end
    T_attributed = table('Size',table_size,'VariableTypes',varTypes, ...
        'VariableNames',animal_sources_unique, ...
        'RowNames',attributed_human_ID);
    for i=1:cP
        T_attributed(:,animal_sources_unique{i}) = table(P(:,i));
    end


end 