function [isolated_nodes,ncc,csc] = testing_thresholds(weighted_matrix,non_weighted_thresholds,sources,node_set)

    thresholds = 1./non_weighted_thresholds;
    ncc = zeros(numel(thresholds),1);
    cc = cell(numel(thresholds),1);
    freq_cc = cell(numel(thresholds),1);
    isolated_nodes = zeros(numel(thresholds),1);
    [rP,cP] = size(weighted_matrix);
    
    sources_per_csc = sources(node_set);
    cc_per_csc = cell(numel(thresholds),1);
    num_cc_per_csc = cell(numel(thresholds),1);
    csc = zeros(numel(thresholds),1);
    
    for k=1:numel(thresholds)
        cmap_prov = zeros(rP,cP);
        for i=1:rP
            for j=1:cP
                if weighted_matrix(i,j) >= thresholds(k)  
                    cmap_prov(i,j) = 1;   
                else
                    cmap_prov(i,j) = 0;
                end
            end
        end
        network = graph(cmap_prov);
        cc{k} = conncomp(network);
              
        cc_per_csc{k} = cc{k}(node_set);
        num_cc_per_csc{k} = unique(cc_per_csc{k});
        [freq_cc{k},~] = histc(cc_per_csc{k},num_cc_per_csc{k});
        isolated_nodes(k) = numel(find(freq_cc{k} == 1));   
        ncc(k) = numel(num_cc_per_csc{k}) - isolated_nodes(k);  

        pos_cc_csc = cell(numel(num_cc_per_csc{k}),1);
        source_cc_csc = cell(numel(num_cc_per_csc{k}),1);
        cat_sources_csc = cell(numel(num_cc_per_csc{k}),1);
        true_positive_per_cc = zeros(numel(num_cc_per_csc{k}),1);
        total_source_per_cc = zeros(numel(num_cc_per_csc{k}),1);
        for w=1:numel(num_cc_per_csc{k})
            pos_cc_csc{w} = find(cc_per_csc{k} == num_cc_per_csc{k}(w));
            source_cc_csc{w} = sources_per_csc(pos_cc_csc{w});
            cat_sources_csc{w} = categorical(source_cc_csc{w});
            true_positive_per_cc(w) = max(countcats(cat_sources_csc{w}));
            total_source_per_cc(w) = sum(countcats(cat_sources_csc{w}));
        end

        csc(k) = (sum(true_positive_per_cc)/sum(total_source_per_cc))*100;
    end
    
end