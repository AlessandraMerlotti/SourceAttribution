function w_matrix = weighted_matrix(D,matrix_type)

    if strcmp(matrix_type,'SNP') == 1
        [r,c] = size(D);
        w_matrix = zeros(r,c);
        for i=1:r
            for j=1:c
                if i==j 
                    w_matrix(i,j) = 0;
                elseif i ~= j && D(i,j) == 0
                    w_matrix(i,j) = 1/0.5;       
                else
                    w_matrix(i,j) = 1./D(i,j);
                end
            end
        end
    elseif strcmp(matrix_type,'cgMLST') == 1 || strcmp(matrix_type,'wgMLST') == 1
        [r,c] = size(D);
        w_matrix = zeros(r,c);
        for i=1:r
            for j=1:c
                if i==j 
                    w_matrix(i,j) = 0;
                elseif i ~= j && D(i,j) == 0 
                    w_matrix(i,j) = 1/0.05;       
                else
                    w_matrix(i,j) = 1./D(i,j);
                end
            end
        end
    end
        

end