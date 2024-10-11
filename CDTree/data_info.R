rm(list = ls())

get_data_info = function(folder_path){
  data_files = list.files(folder_path)
  data_names = rep(0, length(data_files))
  nrow = rep(0, length(data_files))
  ncol = rep(0, length(data_files))
  for(i in 1:length(data_files)){
    f = data_files[i]
    d = read.csv(file = paste0(folder_path, f), header = TRUE)
    data_names[i] = f
    nrow[i] = nrow(d)
    ncol[i] = ncol(d)
  }
  
  
  df_res = data.frame(data_names, nrow, ncol)
  return(df_res)  
}

df_res = get_data_info("./CDTree/permuted_dataset/")



