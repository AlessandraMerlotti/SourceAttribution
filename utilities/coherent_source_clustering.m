function [csc,num_clusters,isolated_nodes] = coherent_source_clustering(threshold_w,weighted_matrix,sources)

    [rP,cP] = size(weighted_matrix);
    cmap = zeros(rP,cP);
    for i=1:rP
        for j=1:cP
            if weighted_matrix(i,j) >= threshold_w
                cmap(i,j) = 1;   
            else
                cmap(i,j) = 0;
            end
        end
    end
    network = graph(cmap);
    cc = conncomp(network);
    num_cc = unique(cc);
    [freq_cc,~] = histc(cc,num_cc);
    isolated_nodes = numel(find(freq_cc == 1));            
    num_clusters = numel(unique(cc)) - isolated_nodes; 
    
    pos_cc_csc = cell(numel(num_cc),1);
    source_cc_csc = cell(numel(num_cc),1);
    cat_sources_csc = cell(numel(num_cc),1);
    true_positive_per_cc = zeros(numel(num_cc),1);
    total_source_per_cc = zeros(numel(num_cc),1);
    for w=1:numel(num_cc)
        pos_cc_csc{w} = find(cc == num_cc(w));
        source_cc_csc{w} = sources(pos_cc_csc{w});
        cat_sources_csc{w} = categorical(source_cc_csc{w});
        true_positive_per_cc(w) = max(countcats(cat_sources_csc{w}));
        total_source_per_cc(w) = sum(countcats(cat_sources_csc{w}));
    end
    
    csc = (sum(true_positive_per_cc)/sum(total_source_per_cc))*100;   
    
end