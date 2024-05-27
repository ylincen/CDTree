construct_leaf_node = function(indices, x_hist, indices_test=NA,
                               cut_value_list=list(), cut_icol_list=list(),
                               cut_operator_list=list()){
  return(list(indices=indices, x_hist=x_hist, indices_test=indices_test,
              cut_value_list = cut_value_list,
              cut_icol_list = cut_icol_list,
              cut_operator_list = cut_operator_list))
}
