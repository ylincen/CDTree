build_tree_with_test_data = function(x, z_matrix, x_test, z_test,
                                     eps, qrf, print_process=TRUE, 
                                     default_grid_number=32){
  # x_test is only used for getting the boundary of the histogram
  # z_hist is used to determine which test instances belong to which leaf node, for prediction later
  #    Predicting a new pair of (x,z) can also be achieved by the other function called predict_new()
  
  node_list = list()
  which_nodes_splitted = list()
  icol_split_list = list() # variables that have been split
  
  left_bound_default = min(c(x, x_test)) - eps
  right_bound_default = max(c(x, x_test)) + eps
  default_x_hist = 
    search_best_num_bin(x, eps, left_bound = left_bound_default,
                        right_bound = right_bound_default,
                        cl_boundary=0, inside_ratio=1)
  default_grid = seq(left_bound_default, right_bound_default, 
                     length.out=default_grid_number)
  
  node_list[[1]] =
    construct_leaf_node(indices=1:length(x), x_hist = default_x_hist,
                        indices_test = 1:length(x_test))
  
  iter = 1
  while(TRUE){
    if(print_process){
      cat("iter: ", iter, "\n")
    }
    
    for(i in 1:length(node_list)){
      node_list[[i]] = search_z_split_with_test(node_list[[i]], x, z_matrix, 
                                      default_x_hist$hist_fixed, 
                                      current_num_leaf_nodes=length(node_list),
                                      eps=eps,
                                      x_test=x_test, z_test=z_test,
                                      qrf=qrf,
                                      default_grid=default_grid)
    }
    
    node_list_update_res = update_node_list(node_list)
    
    if(node_list_update_res$stop_splitting){
      break
    } else{
      which_nodes_splitted[[iter]] = node_list_update_res$which_node_splitted
      node_list = node_list_update_res$node_list
      icol_split_list[[iter]] = node_list_update_res$icol_split
      
      iter = iter + 1
    }
  }
  return(list(node_list = node_list, 
              which_nodes_splitted=which_nodes_splitted, 
              default_hist=default_x_hist,
              icol_split_list=icol_split_list))  
}


search_z_split_with_test = function(node, x, z_matrix, default_hist_x, 
                          current_num_leaf_nodes, eps,
                          x_test, z_test, qrf, default_grid){
  if(!is.null(node$left_child)){
    return(node)
  }
  
  z_num_dim = ncol(z_matrix)
  best_z_split = list(best_gain=-Inf)
  for(icol in 1:z_num_dim){
    split_z_icol_res = 
      search_split(x=x[node$indices], z=z_matrix[node$indices,icol], 
                   z_num_dim=z_num_dim, default_hist_x=default_hist_x, 
                   current_num_leaf_nodes=current_num_leaf_nodes, 
                   node_to_split=node, eps=eps, 
                   z_matrix_local=z_matrix[node$indices,], 
                   qrf=qrf, default_grid=default_grid)  
    if(split_z_icol_res$best_gain > best_z_split$best_gain){
      best_z_split = split_z_icol_res
      best_z_split$z_cut_icol = icol
    }
  }
  
  
  node$z_cut_value = best_z_split$best_z_cut
  node$z_cut_icol = best_z_split$z_cut_icol
  
  left_child_indices = node$indices[z_matrix[node$indices, node$z_cut_icol] < node$z_cut_value]
  right_child_indices = node$indices[z_matrix[node$indices, node$z_cut_icol] >= node$z_cut_value]
  
  left_child_indices_test = node$indices_test[z_test[node$indices_test, node$z_cut_icol] < node$z_cut_value]
  right_child_indices_test = node$indices_test[z_test[node$indices_test, node$z_cut_icol] >= node$z_cut_value]
  
  
  cut_value_list = node$cut_value_list
  cut_value_list[[length(cut_value_list) + 1]] = node$z_cut_value
  cut_icol_list = node$cut_icol_list
  cut_icol_list[[length(cut_icol_list) + 1]] = node$z_cut_icol
  left_cut_operator_list = node$cut_operator_list
  right_cut_operator_list = node$cut_operator_list
  left_cut_operator_list[[length(left_cut_operator_list) + 1]] = "<"
  right_cut_operator_list[[length(right_cut_operator_list) + 1]] = ">="
  
  node$left_child = 
    construct_leaf_node(indices = left_child_indices, 
                        x_hist = best_z_split$best_hist$x_left_hist, 
                        indices_test = left_child_indices_test,
                        cut_value_list = cut_value_list,
                        cut_icol_list = cut_icol_list,
                        cut_operator_list = left_cut_operator_list)
  node$right_child = 
    construct_leaf_node(indices = right_child_indices, 
                        x_hist = best_z_split$best_hist$x_right_hist,
                        indices_test = right_child_indices_test,
                        cut_value_list = cut_value_list,
                        cut_icol_list = cut_icol_list,
                        cut_operator_list = right_cut_operator_list)
  
  node$left_child$"mother_split" = list(z_cut_icol=best_z_split$z_cut_icol, 
                                        z_cut_value=best_z_split$best_z_cut)
  node$right_child$"mother_split" = list(z_cut_icol=best_z_split$z_cut_icol, 
                                         z_cut_value=best_z_split$best_z_cut)
  
  node$gain_after_split = best_z_split$best_gain
  node$cl_model_change_after_split = best_z_split$tree_cl_model_change
  
  return(node)
}

update_node_list = function(node_list){
  gains = lapply(node_list, function(nd) nd$gain_after_split)
  which_max_gain = which.max(gains)
  
  if(gains[which_max_gain] < 0){
    stop_splitting=TRUE
    icol_split = NA
  } else{
    stop_splitting=FALSE
    
    icol_split = node_list[[which_max_gain]]$z_cut_icol
    # split the node and only keep the children
    node_list[[length(node_list) + 1]] = node_list[[which_max_gain]]$right_child
    node_list[[which_max_gain]] = node_list[[which_max_gain]]$left_child
  }
  return(list(stop_splitting=stop_splitting, node_list=node_list, 
              which_node_splitted = which_max_gain, 
              icol_split=icol_split))
}
