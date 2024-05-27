rm(list=ls())
set.seed(1)
datasets = c("NavalPropolsion_permu", 
             "forestfires_permu",
             "superconductivity_permu",
             "concrete_permu",
             "localization_permu",
             "synchronous_permu",
             "energy_permu",
             "slump_permu",
             "toxicity_permu",
             "SkillCraft",
             "support2",
             "Thermography",
             "studentmath",
             "sml2010")
data_path = "./conditional_entropy_estimation_fixed_hist/permuted_dataset_noiseadded/"
new_data_path = "./conditional_entropy_estimation_fixed_hist/permuted_dataset_noiseadded_addingIndFeature/"

# create a folder if not exist
if(!dir.exists(new_data_path)){
  dir.create(new_data_path)
}

for(data_name in datasets){
  d = read.csv(file = paste(data_path, data_name, ".csv", sep=""))
  cat(data_name, ncol(d), "\n")
  for(num_indep_features in c(3,5,10,20)){
    added_cols = matrix(rnorm(nrow(d) * num_indep_features), nrow = nrow(d))
    d_new = cbind(added_cols, d)
    write.csv(d_new, file = paste(new_data_path,
                                  data_name, "_", num_indep_features,
                                  "_indep_features.csv", sep=""),
              row.names = FALSE)
  }
}

new_dep_data_path = "./conditional_entropy_estimation_fixed_hist/permuted_dataset_noiseadded_addingDepFeature/"

# create a folder if not exist
if(!dir.exists(new_dep_data_path)){
  dir.create(new_dep_data_path)
}

for(data_name in datasets){
  d = read.csv(file = paste(data_path, data_name, ".csv", sep=""))
  cat(data_name, ncol(d), "\n")
  for(num_dep_features in c(3,5,10,20)){
    added_cols = matrix(rep(0, nrow(d) * num_dep_features), nrow = nrow(d))
    if(num_dep_features > ncol(d) - 1){
      which_col_base = sample(1:(ncol(d)-1), num_dep_features, replace = T)  
    } else{
      which_col_base = sample(1:(ncol(d)-1), num_dep_features, replace = F)
    }
    for(i in 1:num_dep_features){
      sd_set = max(sd(d[,which_col_base[i]]) * 0.5)
      added_noise = rnorm(nrow(d), sd = sd_set)
      added_cols[,i] = d[,which_col_base[i]] + added_noise
    }
    d_new = cbind(added_cols, d)
    write.csv(d_new, file = paste(new_data_path, 
                                  data_name, "_", num_dep_features, 
                                  "_dep_features.csv", sep=""), 
              row.names = FALSE)
  }
}

