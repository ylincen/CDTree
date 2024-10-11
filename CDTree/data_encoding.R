require(SCCI)

get_cl_data = function(hist_fixed, x, ratio_inside){
  counts = hist_fixed$counts
  p_hat = counts / sum(counts)

  bin_widths = diff(hist_fixed$breaks)
  density_hat = p_hat / bin_widths
  
  
  negloglike = -sum(log2(density_hat[density_hat != 0]) * 
                      hist_fixed$counts[density_hat != 0])
  
  nml_regret = regret(length(x), length(hist_fixed$counts))
  
  return(negloglike + nml_regret)
}
