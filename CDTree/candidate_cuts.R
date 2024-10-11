generate_cuts_and_clforcuts = function(z){
  l = 4   # essentially a search budget, deciding the maximum granularity
  C = 5
  cut_points_length = C * 2 ^ (0:l)

  # check if z is binary
  if(length(unique(z)) == 2){
    cut = mean(unique(z))
    cuts_list = list()
    cuts_cl = rep(0, length(cut_points_length))
    for(i in 1:length(cut_points_length)){
      cuts_list[[i]] = cut
      cuts_cl[i] = 0
    }
  } else{
    cuts_list = list()
    cuts_cl = rep(0, length(cut_points_length))
    for(i in 1:length(cut_points_length)){
      candidate_cuts_and_its_cl = get_cuts_for_z(z, cut_points_length[i])
      cuts_list[[i]] = candidate_cuts_and_its_cl$cuts
      cuts_cl[i] = candidate_cuts_and_its_cl$cl
    }
  }
  return(list(cuts_list=cuts_list, cuts_cl=cuts_cl))
}

get_cuts_for_z = function(z, cut_points_length){
  # Generate candidate cut points for z
  # cut_point_length: length of the cut points vector
  
  # return(get_cuts_for_z_equal_binning)
  return(get_cuts_for_z_quantile(z, cut_points_length))
}

get_cuts_for_z_quantile = function(z, cut_points_length){
  ps = seq(0, 1, length.out=cut_points_length + 2)
  cuts = quantile(z, probs = ps[2:(length(ps)-1)])
  
  true_length = length(unique(cuts))
  
  granularity = log2(true_length) + 1
  cl_granularity = Rissanen_integer_cl(granularity)
  cl_cut = log2(true_length)
  
  return(list(cuts=cuts, cl=cl_cut+cl_granularity))
}

get_cuts_for_z_equal_binning = function(z, cut_points_length){
  cuts = seq(min(z), max(z), length.out=cut_points_length + 2)
  granularity = log2(cut_points_length)
  cl_granularity = Rissanen_integer_cl(granularity)
  cl_cut = log2(cut_points_length)
  
  return(list(cuts=cuts, cl=cl_cut+cl_granularity))
}