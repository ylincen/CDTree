predict_CDTree = function(tree, x_test, z_test){
  # This is a function that predicts the CDE of new data points
  # Inputs:
  # tree: a CDTree trained on some training set
  # x_test: target value of the test data
  # z_test: feature matrix of the test data
  
  # Output:
  # a vector of predicted density estimates

  test_indices_list = cover_test_data(tree, x_test, z_test)
  
  log_density_x = rep(NA, length(x_test))
  for(i in 1:length(test_indices_list)){
    test_indices_ = test_indices_list[[i]]
    leaf_node = tree$node_list[[i]]
    if(length(test_indices_) > 0){
      log_density_x_ = predict_x_given_z_leaf(leaf_node, x_test[test_indices_])
      log_density_x[test_indices_] = log_density_x_
    }
  }
  return(log_density_x)
}

predict_x_given_z_leaf = function(leaf_node, x_){
  # This function predicts the CDE of new data points, assuming that they fall into this leaf node
  # Inputs:
  # leaf_node: a leaf node in the CDTree
  # x_: a vector of target variables
  
  # Output:
  # a vector of predicted density estimates
  
  hist_ = leaf_node$x_hist$hist_fixed
  counts = hist_$counts + 1
  density_ = counts / sum(counts) / diff(hist_$breaks)[1]
  log_density_ = log(density_)
  
  # get which intervals 
  breaks_ = hist_$breaks
  which_intervals = findInterval(x_, breaks_, all.inside=F)
  if(0 %in% which_intervals | length(breaks_) %in% which_intervals){
    # if the target variable is outside the range of the histogram
    stop("The target variable is outside the range of the histogram; re-train the model by updating the range of the target variable")
  }
  
  log_density_x = log_density_[which_intervals]
    
  return(log_density_x)
  
}

cover_test_data = function(tree, x_test, z_test){
  # This function gets the cover of each leaf node in the tree for the test data
  # Inputs & outputs same as "predict_CDTree"
  
  test_indices_list = list()
  for(i in 1:length(tree$node_list)){
    node = tree$node_list[[i]]
    
    split_icol_list = node$cut_icol_list
    split_value_list = node$cut_value_list
    split_operator_list = node$cut_operator_list
    
    test_indices = 1:length(x_test)
    for(j in 1:length(split_icol_list)){
      split_icol = split_icol_list[[j]]
      split_value = split_value_list[[j]]
      split_operator = split_operator_list[[j]]
      
      if(split_operator == "<"){
        bool_ = (z_test[test_indices, split_icol] < split_value)
      } else{
        bool_ = (z_test[test_indices, split_icol] >= split_value)
      }
      
      # note that the length of bool_ is the same as the length of test_indices, 
      # both of which will keep changing. 
      test_indices = test_indices[bool_]
    }
    
    test_indices_list[[i]] = test_indices
  }
  
  return(test_indices_list)
}

