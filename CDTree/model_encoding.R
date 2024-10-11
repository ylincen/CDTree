# This file collects functions that are used to calculate the code length needed
#.  to encode model under the MDL framework. 

get_cl_model_tree_change = function(num_leaf_nodes){
  current_cl_model_tree = Rissanen_integer_cl(num_leaf_nodes) + 
    log2_catalan(num_leaf_nodes - 1)  
  potential_cl_model_tree = Rissanen_integer_cl(num_leaf_nodes + 1) + 
    log2_catalan(num_leaf_nodes + 1 - 1)
  return(list(potential_cl_model_tree=potential_cl_model_tree,
              current_cl_model_tree=current_cl_model_tree))
}


Rissanen_integer_cl = function(n){
  # Page 100, Grunwald book (2007)
  if(n < 1){
    stop("Integer code only applies to positive integers")
  }

  c0 = 2.865
  cl = log2(c0)
  
  to_add = n
  while(TRUE){
    if(log2(to_add) > 0){
      cl = cl + log2(to_add)
      to_add = log2(to_add)
    } else{
      return(cl)
    }
  }
}

log2_catalan = function(n_internal_nodes){
  if(n_internal_nodes <= 1){  # for 0 and 1 internal nodes; 
    return(0)
  } else{
    k = 2:n_internal_nodes
    return(sum(log2((n_internal_nodes + k) / k)))  
  }
}