construct_leaf_node = function(indices, x_hist, indices_test=NA,
                               cut_value_list=list(), cut_icol_list=list(),
                               cut_operator_list=list()){
  # This function creates a list to store relevant information for a leaf node
  #  indices: indices of the training data that fall into this leaf node
  #  x_hist: histogram of the response variable in this leaf node
  #  indices_test (if provided): indices of the test data that fall into this leaf node
  
  # Additionally, through the following three lists, we can keep track of the root-to-leaf
  #     path that leads to this leaf node.    
  #  cut_value_list: the list of all cut values that lead to this leaf node
  #  cut_icol_list: the list of all feature indices (i.e., the index of columns) 
  #         that lead to this leaf node
  #  cut_operator_list: the list of all operators ('<' or ">=") that lead to this leaf node
  
  return(list(indices=indices, x_hist=x_hist, indices_test=indices_test,
              cut_value_list = cut_value_list,
              cut_icol_list = cut_icol_list,
              cut_operator_list = cut_operator_list))
}
