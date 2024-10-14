search_best_num_bin = function(x, eps, cl_boundary, inside_ratio,
                               left_bound, right_bound, default_hist_x=NULL,
                               num_gap = 30,
                               len = 2){
  # This function constructs a histogram with the best number of bins that optimize the MDL score
  # Inputs: 
  #   x: the data point;
  #   eps: data precision (see the comment of the function build_tree)
  #   num_gap & len: parameters for a heuristic that speeds up the search for the best number of bins; see the paper for more details. 
  #   cl_boundary, inside_ratio, default_hist_x: all deprecated!!
  
  n = length(x)

  stopifnot(!is.null(left_bound), !is.null(right_bound))
  
  previous_cl_total = Inf
  previous_discrete_entropy = Inf
  # while(TRUE){
  while(( max(x) - min(x) ) / len > eps){
    cl_total_res = get_hist_cl_total(len, x, left_bound, right_bound, 
                                 cl_boundary, inside_ratio,
                                 default_hist_x, 
                                 return_discrete_entropy=T)
    cl_total = cl_total_res$total_cl
    discrete_entropy = cl_total_res$discrete_entropy
    if(cl_total < previous_cl_total){
      previous_cl_total = cl_total
      previous_discrete_entropy = discrete_entropy
      len = len + num_gap
    } else {
      break
    }
  }
  start_len = max(2, len - 2 * num_gap)
  end_len = len
  
  hist_cl_list_res = sapply(start_len:end_len, 
                        get_hist_cl_total, 
                        x, left_bound, right_bound, 
                        cl_boundary, inside_ratio, default_hist_x, 
                        return_discrete_entropy=T)
  hist_cl_list = unlist(hist_cl_list_res['total_cl',])
  best_len = (start_len:end_len)[which.min(hist_cl_list)]
  
  best_hist = hist(x, plot = F, 
                   breaks = seq(left_bound, right_bound, 
                                length.out=best_len))
  best_negloglike = 
    sum(
      -log2(best_hist$density[best_hist$counts != 0]) * 
        best_hist$counts[best_hist$counts != 0]
    )
  
  counts = best_hist$counts + 1  # Laplacian smooth
  
  # leave-one-out density with Laplacian smooth
  #   (This is a function that is developed but not used in our experiment)
  loo_density = (counts - 1) / (length(x) + length(counts) - 1) / diff(best_hist$breaks)
  loo_density_x = loo_density[findInterval(x, best_hist$breaks)]
  loo_negloglike = -sum(log2(loo_density_x[loo_density_x != 0]))
  
  best_sc = best_negloglike + regret(n, length(best_hist$counts))
  return(list(hist_fixed=best_hist, score=min(hist_cl_list), 
              negloglike=best_negloglike, sc=best_sc,
              loo_negloglike = loo_negloglike, 
              loo_density_x = loo_density_x))
}

get_hist_cl_total = function(len, x, left_bound, right_bound, 
                             cl_boundary, inside_ratio, default_hist=NULL,
                             return_discrete_entropy=F){
  # len: length of the cut points for histograms, including the boundaries; 
  # x: the data point;
  
  cuts = seq(left_bound, right_bound, length.out=len)
  
  which_min = which.min(x); x_min = x[which_min]
  which_max = which.max(x); x_max = x[which_max]

  hist_fixed = hist(x, plot=F, breaks = cuts)
  cl_data = get_cl_data(hist_fixed, x, inside_ratio)
  
  cl_boundary = cl_boundary
  
  
    
  # get cl_num_bins
  num_bins = length(hist_fixed$counts)
  cl_num_bins = Rissanen_integer_cl(num_bins)
  cl_model = cl_num_bins + cl_boundary
  if(return_discrete_entropy){
    hist_counts = hist_fixed$counts
    hist_counts = hist_counts[hist_counts != 0]
    discrete_entropy = -sum(hist_counts * log2(hist_counts / sum(hist_counts)))
    return(list(total_cl = cl_data + cl_model, 
                discrete_entropy = discrete_entropy))
  } else{
    return(cl_data + cl_model)
  }
  
}

