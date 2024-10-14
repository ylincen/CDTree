rm(list=ls())
options(warn=0)
source("./CDTree/data_encoding.R")
source("./CDTree/hist.R")
source("./CDTree/candidate_cuts.R")
source("./CDTree/model_encoding.R")
source("./CDTree/search.R")
source("./CDTree/Node.R")
source("./CDTree/build_tree.R")
source("./CDTree/get_test_log_likelihood.R")

args = commandArgs(trailingOnly=TRUE)

if(length(args) == 0){
  # for test the code only
  data_name = "localization_3_indep_features"
  file_path = paste("./CDTree/permuted_dataset_noiseadded_addingFeature/", data_name, ".csv", sep="")  
} else{
  data_name = args[1]
  file_path = paste("./CDTree/permuted_dataset_noiseadded_addingFeature/", data_name, ".csv", sep="")  
}


d = read.csv(file = file_path)

z = as.matrix(d[,1:(ncol(d)-1)])
x = as.matrix(d[,ncol(d)])

groups = rep(c(1,2,3,4,5), each=ceiling(length(x)/5))
test_indice_list = split(1:length(x), groups[1:length(x)])

time_for_file_name = strsplit(as.character(Sys.time()), " ")[[1]][2]
date_for_file_name = Sys.Date()
date_and_time = paste(date_for_file_name, time_for_file_name, sep="_")

negloglikes = rep(NA, 5)
runtimes = rep(NA, 5)
numLeafs = rep(NA, 5)
meanNumBins = rep(NA, 5)
negloglikes_train = rep(NA, 5)
num_split_wrong_features = rep(NA, 5)

data_name_split = strsplit(data_name, "_")[[1]]
for(word in data_name_split){
  # if(is.numeric(word)){
  if (grepl("[0-9]", word)) {
    num_added_feature = as.numeric(word)
    if(num_added_feature %in% c(3,5,10,20)){
      break
    }
  }
}


for(cv in 1:5){
  if(length(args) == 2){
    if(cv != args[2]){
      break()
    }
  }
  if(length(args) == 0){
    cat("test mode, with only cv: ", cv, "\n")
    if(cv != 1){
      next()
    }
  }
  cat("fold ", cv, "file ", file_path, "\n")
  
  test_index = test_indice_list[[cv]]
  x_train = x[-test_index,]
  z_train = z[-test_index,]
  x_test = x[test_index,]
  z_test = z[test_index,]
  start_time = Sys.time()
  tree = build_tree(x=x_train, z_matrix=z_train, 
                                   x_test=x_test, z_test=z_test,
                                   eps=1e-3, print_process = F)
  end_time = Sys.time()
  
  res = get_test_log_likelihood(x_train, x_test, tree)
  negloglikes[cv] = res[[1]] / length(x_test)
  negloglikes_train[cv] = res[[3]] / length(x)
  runtimes[cv] = as.numeric(difftime(end_time, start_time, units = "secs"))
  numLeafs[cv] = length(tree[[1]])
  meanNumBins[cv] = mean(sapply(tree[[1]], function(z){length(z$x_hist$hist_fixed$counts)}))
  num_split_wrong_features[cv] = sum(unlist(tree$icol_split_list) <= 
                                       num_added_feature,
                                     na.rm = T)
}

res_df = data.frame(negloglikes, negloglikes_train, runtimes,
                    numLeafs, meanNumBins, num_split_wrong_features)
res_df$data = data_name

if("indep" %in% data_name_split){
  save_dir = paste("./CDTree/res_cde_scalability/", 
                   date_for_file_name, "_indep/", sep="")
} else if("dep" %in% data_name_split){
  save_dir = paste("./CDTree/res_cde_scalability/", 
                   date_for_file_name, "_dep/", sep="")
} else{
  stop("data_name should contain either 'indep' or 'dep'")
}

if(!dir.exists(save_dir)){
  dir.create(save_dir, recursive = T)
}
res_file_path = paste(save_dir,
                      data_name, "_", date_and_time, ".csv", sep="")

res_df$num_added_feature = num_added_feature
if(length(args) > 0){
  write.csv(res_df, res_file_path, row.names = F)  
}







