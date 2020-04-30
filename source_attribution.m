function [T_attributed,T_not_attributed,adjacency_matrix_fh] = source_attribution(D_fh,metadata_fh,best_threshold,matrix_type)

    % REQUIRED INPUT VARIABLES
    % D_fh = pairwise distance matrix comprising both animal and human
    % origin samples in .mat format
    
    % metadata = two columns cell array in .mat format; the first column 
    % contains sample IDs sorted as in D_fh, the second column contains
    % the corresponding primary source (animal or human origin).
    % Human origin samples must be labeled as 'Human' within the second
    % column.
    
    % best_threshold = best_threshold computed via source_clustering.m
    
    % matrix_type = is a char array indicating the type of pairwise
    % distance matrix to be analyzed: 'SNP', 'cgMLST' or 'wgMLST'
    
    w_fh = weighted_matrix(D_fh,matrix_type);
    adjacency_matrix_fh = matrix_thresholding(w_fh,best_threshold);
    
    sources_fh = metadata_fh(:,2);
    nodes_human = find(strcmp(sources_fh,'Human'));
    
    [T_attributed,T_not_attributed] = attribution_probability(adjacency_matrix_fh,nodes_human,metadata_fh);
    
    t1 = horzcat('T_not_attributed_',matrix_type,'.txt');
    t2 = horzcat('T_attributed_',matrix_type,'.txt');
    
    writetable(T_not_attributed,t1,'WriteRowNames',true);
    writetable(T_attributed,t2,'WriteRowNames',true);
    

end
