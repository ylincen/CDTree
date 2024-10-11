get_test_log_likelihood = 
  function(x_train, x_test, tree, return_log2=F){
    node_list = tree$node_list
    default_hist = tree$default_hist
    
    neg_log_likelihood = 0
    neg_log_likelihood_train = 0
    log_density_pred_all = list()
    log_density_train_all = list()
    sum_within = 0
    
    test_density_each = rep(NA, length(x_test))
    train_density_each = rep(NA, length(x_train))
    
    outsider_negloglike = 0
    insider_negloglike = 0
    for(node_i in 1:length(node_list)){
      nd = node_list[[node_i]]
      tr_index = nd$indices
      ts_index = nd$indices_test
      hist_cuts = nd$x_hist$hist_fixed$breaks
      
      counts = nd$x_hist$hist_fixed$counts + 1 # Laplacian correction
      p_hat = counts / sum(counts) 
      
      bin_widths = diff(hist_cuts)
      density_hat = p_hat / bin_widths
      
      intvals_test = findInterval(x_test[ts_index], hist_cuts)
      density_pred = rep(NA, length(intvals_test))
  
      density_pred = density_hat[intvals_test]
      test_density_each[ts_index] = density_pred
      
      neg_log_likelihood = neg_log_likelihood - sum(log2(density_pred))
      log_density_pred_all[[node_i]] = -log2(density_pred)
      
      intvals_train = findInterval(x_train[tr_index], hist_cuts)
      density_train = density_hat[intvals_train]
      train_density_each[tr_index] = density_train
      
      neg_log_likelihood_train = neg_log_likelihood_train - sum(log2(density_train))
      log_density_train_all[[node_i]] = -log2(density_train)
    }
    log_density_train_all = unlist(log_density_train_all)
    log_density_pred_all = unlist(log_density_pred_all)
    if(!return_log2){
      neg_log_likelihood = neg_log_likelihood / log2(exp(1))
      neg_log_likelihood_train = neg_log_likelihood_train / log2(exp(1))
      log_density_pred_all = log_density_pred_all / log2(exp(1))
      log_density_train_all = log_density_train_all / log2(exp(1))
      outsider_negloglike = outsider_negloglike / log2(exp(1))
      insider_negloglike = insider_negloglike / log2(exp(1))
    }

    return(list(neg_log_likelihood=neg_log_likelihood, 
                log_density_pred_all=log_density_pred_all,
                neg_log_likelihood_train=neg_log_likelihood_train,
                log_density_train_all=log_density_train_all, 
                outsider_negloglike=outsider_negloglike, 
                insider_negloglike=insider_negloglike,
                train_density_each=train_density_each,
                test_density_each=test_density_each))
}

