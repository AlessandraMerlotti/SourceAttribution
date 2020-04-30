function binary_matrix = matrix_thresholding(w_food,best_threshold)

    threshold = 1/best_threshold;
    [r,c] = size(w_food);
    binary_matrix = zeros(r,c);
    for i=1:r
        for j=1:c
            if w_food(i,j) >= threshold   
                binary_matrix(i,j) = 1;   
            else
                binary_matrix(i,j) = 0;
            end
        end
    end

    
end