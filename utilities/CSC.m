function csc = CSC(adjacency_matrix,sources)

    cmap = graph(adjacency_matrix);
    sources_per_csc = sources;
    cc = conncomp(cmap);
    cc_per_csc = cc;
    num_cc_per_csc = unique(cc_per_csc);

    pos_cc_csc = cell(numel(num_cc_per_csc),1);
    source_cc_csc = cell(numel(num_cc_per_csc),1);
    cat_sources_csc = cell(numel(num_cc_per_csc),1);
    true_positive_per_cc = zeros(numel(num_cc_per_csc),1);
    total_source_per_cc = zeros(numel(num_cc_per_csc),1);

    sources_unique_cc = cell(numel(num_cc_per_csc),1);
    source_counts_per_cc = cell(numel(num_cc_per_csc),1);
    pos_max_per_cc = zeros(numel(num_cc_per_csc),1);
    main_source_per_cc = cell(numel(num_cc_per_csc),1);

    for k=1:numel(num_cc_per_csc)
        pos_cc_csc{k} = find(cc_per_csc == num_cc_per_csc(k));
        source_cc_csc{k} = sources_per_csc(pos_cc_csc{k});
        cat_sources_csc{k} = categorical(source_cc_csc{k});
        true_positive_per_cc(k) = max(countcats(cat_sources_csc{k}));
        total_source_per_cc(k) = sum(countcats(cat_sources_csc{k}));

        sources_unique_cc{k} = categories(cat_sources_csc{k});
        source_counts_per_cc{k} = countcats(cat_sources_csc{k});
        pos_max_per_cc(k) = find(source_counts_per_cc{k} == true_positive_per_cc(k),1,'first');
        main_source_per_cc{k} = sources_unique_cc{k}(pos_max_per_cc(k));
    end

    csc = (sum(true_positive_per_cc)/sum(total_source_per_cc))*100;

end 