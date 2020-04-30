function [best_threshold,csc,adjacency_matrix_food] = source_clustering(D_food,metadata,matrix_type)

    % REQUIRED INPUT VARIABLES
    % D_food = pairwise distance matrix comprising only animal origin
    % samples in .mat format
    
    % metadata = two columns cell array in .mat format; the first column
    % contains sample IDs sorted as in D_food, the second column contains
    % the corresponding primary source (animal origin only)
    
    % matrix_type = is a char array indicating the type of pairwise
    % distance matrix to be analyzed: 'SNP', 'cgMLST' or 'wgMLST'

    sources = metadata(:,2);
    w_food = weighted_matrix(D_food,matrix_type);
    disp('Running cross-validation ...');
    best_threshold = cv_70_30(D_food,w_food,sources);
    display(best_threshold,'Best threshold');
    adjacency_matrix_food = matrix_thresholding(w_food,best_threshold);
    csc = CSC(adjacency_matrix_food,sources);

end
