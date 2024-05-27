search_split = function(x, z, z_num_dim, default_hist_x, 
                        current_num_leaf_nodes, node_to_split,
                        eps, z_matrix_local, qrf, default_grid){
  # OUTPUT: 
  # list(best_hist=best_hist_all_layers, best_gain=best_gain_all_layers, 
  #      best_z_cut = best_z_cut_all_layers)
  #  in which: 
  #  best_hist = list(x_left_hist=x_left_hist, x_right_hist=x_right_hist)
  
  cuts_and_cl = generate_cuts_and_clforcuts(z)
  cuts_list = cuts_and_cl$cuts_list; cuts_cl = cuts_and_cl$cuts_cl
  
  # check repeated cuts
  cuts_flat = unlist(cuts_list)
  duplicated_indices = which(duplicated(cuts_flat))
  
  best_gain_all_layers = -Inf
  best_hist_all_layers = NULL; best_z_cut_all_layers = NULL
  tree_cl_model_change = NULL
  for(i_list in 1:length(cuts_list)){
    # cat("i_list: ", i_list, "\n")
    cuts = cuts_list[[i_list]]
    cut_cl = cuts_cl[i_list]
    
    best_gain_this_layer = -Inf
    if(length(unique(cuts)) <= 2 && i_list != length(cuts_list)){
      next()
    }
    for(i_cut in 1:length(cuts)){
      left_bool = (z < cuts[i_cut])
      right_bool = (z >= cuts[i_cut])
      x_left = x[left_bool]
      x_right = x[right_bool]

      if(length(x_left) <= 2 | length(x_right) <= 2){
        next()
      }
      x_left_hist = 
        search_best_hist_and_boundary(x_left, eps=eps, 
                                      default_grids=default_grid,
                                      inside_ratio=1,
                                      lo_quantile=NULL,
                                      up_quantile=NULL)
      x_right_hist = 
        search_best_hist_and_boundary(x_right, 
                                      eps=eps,
                                      default_grids=default_grid,
                                      inside_ratio=1,
                                      lo_quantile=NULL,
                                      up_quantile=NULL)
      
      other_nodes_total_cl = 0  # This is a constant that will cancel out; we put it here for interpretability
      tree_cl_model_change = get_cl_model_tree_change(current_num_leaf_nodes)
      
      change_in_regret_boundaries = 0 # For making the code more readable
      change_caused_by_encoding_default_hist = 0 # For making the code more readable
      
      total_cl_after_split = 
        tree_cl_model_change$potential_cl_model_tree + # bits for num_leaf_nodes and the structure
        x_left_hist$score + x_right_hist$score + # bits for the histograms + cl_data
        cut_cl + log2(z_num_dim) +  # bits for the cut
        other_nodes_total_cl + # constant that will cancel out
        change_in_regret_boundaries + 
        change_caused_by_encoding_default_hist
      total_cl_before_split = 
        tree_cl_model_change$current_cl_model_tree + # bits for num_leaf_nodes and the structure
        node_to_split$x_hist$score + # bits for histograms + cl_data
        other_nodes_total_cl  # constant that will cancel out
      
      if(total_cl_before_split - total_cl_after_split > best_gain_this_layer){
        best_gain_this_layer = total_cl_before_split - total_cl_after_split
        best_hist = list(x_left_hist=x_left_hist, x_right_hist=x_right_hist)
        best_z_cut = cuts[i_cut]
      }
    }
    
    if(best_gain_this_layer > best_gain_all_layers){
      best_gain_all_layers = best_gain_this_layer
      best_hist_all_layers = best_hist
      best_z_cut_all_layers = best_z_cut
    } else{
      break
    }
  }
  return(list(best_hist=best_hist_all_layers, best_gain=best_gain_all_layers,
              best_z_cut = best_z_cut_all_layers, 
              tree_cl_model_change=tree_cl_model_change))
}





search_best_hist_and_boundary = function(x, up_quantile, lo_quantile, eps, default_grids, 
                                         inside_ratio){

  left_boundary = default_grids[1]
  right_boundary = default_grids[length(default_grids)]
  
  best_hist_res =
    search_best_num_bin(x,
                        left_bound = left_boundary,
                        right_bound = right_boundary,
                        eps=eps,
                        cl_boundary = 0,
                        inside_ratio=inside_ratio)
  
  return(best_hist_res)

}
