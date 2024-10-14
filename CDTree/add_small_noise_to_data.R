rm(list = ls())

datasets = c("NavalPropolsion", 
             "forestfires",
             "superconductivity",
             "concrete",
             "localization",
             "synchronous",
             "energy",
             "slump",
             "toxicity",
             "SkillCraft",
             "support2",
             "Thermography",
             "studentmath",
             "sml2010")
data_path = "./CDTree/permuted_dataset/"
new_data_save = "./CDTree/permuted_dataset_noiseadded/"
# create a folder if not exist
if(!dir.exists(new_data_save)){
  dir.create(new_data_save)
}

for(data_name in datasets){
  file_path = paste(data_path, data_name, ".csv", sep="")
  d = read.csv(file = file_path)
  z = as.matrix(d[,1:(ncol(d)-1)])
  x = as.matrix(d[,ncol(d)])
  
  # check whether the target variable is a like discrete
  unique_ratio = length(unique(x)) / length(x)
  # if(unique_ratio < 0.2){
  #   type_target = "discrete"
  #   cat(data_name, "is a discrete dataset\n")
  # } else{
  #   cat(data_name, "is a continuous dataset\n")
  #   type_target = "continuous"
  # }
  
  # add a small noise to the feature/target variable to make 
  # it "real" continuous for both target and feature variables
  for(icol in 1:ncol(z)){
    sd_added = sd(z[,icol]) * 0.01
    if(sd_added == 0){
      sd_added = 0.001
    }
    z[,icol] = z[,icol] + rnorm(length(z[,icol]), sd=sd_added)
  }
  sd_added = sd(x) * 0.01
  if(sd_added == 0){
    sd_added = 0.001
  }
  x = x + rnorm(length(x), sd=sd_added)
  
  d_new = cbind(z, x)
  # write.csv(d_new, file = paste(new_data_save, 
  #                               data_name, ".csv", sep=""), 
  #           row.names = FALSE)
}
