function best_threshold = cv_70_30(D_food,w_food,sources_food)

    n_food = length(w_food);
    n_repeat = 100;      

    indices = cell(n_repeat,1);
    train_size = zeros(n_repeat,1);
    test_size = zeros(n_repeat,1);
    train_idx = cell(n_repeat,1);
    test_idx = cell(n_repeat,1);

    values_distance_train = cell(n_repeat,1); 
    threshold_train = cell(n_repeat,1); 

    best_thresholds_distance = cell(n_repeat,1);
    best_threshold_d_train = zeros(n_repeat,1);
   
    w_test = cell(n_repeat,1);
    sources_test = cell(n_repeat,1);
    csc_test = zeros(n_repeat,1);
    ncc_test = zeros(n_repeat,1);
    isolated_nodes_test = zeros(n_repeat,1);
    score_test = zeros(n_repeat,1);

    for k=1:n_repeat
        disp(k);
        indices{k} = randperm(n_food);
        train_size(k) = round((n_food/100)*70);   % 70% training 
        test_size(k) = n_food - train_size(k);    % 30% test

        train_idx{k} = indices{k}(1:train_size(k));      
        test_idx{k} = indices{k}(train_size(k)+1:end);

        % TRAINING
        values_distance_train{k} = unique(D_food(train_idx{k},train_idx{k}));
        threshold_train{k} = 1./values_distance_train{k};
        [isolated_nodes,number_conn_comp,csc] = testing_thresholds(w_food,values_distance_train{k},sources_food,train_idx{k});
        score = (1 - isolated_nodes./train_size(k)).*csc;
        max_score = max(score);
        pos_max_score = find(score == max_score);
        best_thresholds_distance{k} = values_distance_train{k}(pos_max_score);
        best_threshold_d_train(k) = best_thresholds_distance{k}(end);

        % TEST
        w_test{k} = w_food(test_idx{k},test_idx{k});
        sources_test{k} = sources_food(test_idx{k});
        [csc_test(k),ncc_test(k),isolated_nodes_test(k)] = coherent_source_clustering(1/best_threshold_d_train(k),w_test{k},sources_test{k});
        score_test(k) = (1 - isolated_nodes_test(k)/test_size(k))*csc_test(k);
        
    end

    best_threshold = mode(best_threshold_d_train);


end