#!/bin/bash

# Array of base dataset names without permutation and feature type suffix
datasets=(
    "slump"
    "SkillCraft"
    "sml2010"
    "synchronous"
    "localization"
    "toxicity"
)

# Permutations array
permutations=("3" "5" "10" "20")

# Loop through the datasets
for dataset in "${datasets[@]}"; do
    # Loop through permutations
    for perm in "${permutations[@]}"; do
        # Define file names for independent features
        indep_file="${dataset}_${perm}_indep_features"
        
        echo "Processing dataset: $dataset with number of indep features added: $perm"
        
        # Run R script for independent features file if it exists
        Rscript ./conditional_entropy_estimation_fixed_hist/run_cde.R "$indep_file" &
    done
done

wait 


for dataset in "${datasets[@]}"; do
    # Loop through permutations
    for perm in "${permutations[@]}"; do
        # Define file names for dependent features
        dep_file="${dataset}_${perm}_dep_features"
        
        echo "Processing dataset: $dataset with number of dep features added: $perm"

        Rscript ./conditional_entropy_estimation_fixed_hist/run_cde.R "$dep_file" & 
    done
done

wait 


#################

datasets=(
    "Thermography"
    "studentmath"
    "concrete"
    "energy"
    "forestfires"
)

# Permutations array
permutations=("3" "5" "10" "20")

# Loop through the datasets
for dataset in "${datasets[@]}"; do
    # Loop through permutations
    for perm in "${permutations[@]}"; do
        # Define file names for independent features
        indep_file="${dataset}_${perm}_indep_features"
        
        echo "Processing dataset: $dataset with number of indep features added: $perm"
        
        # Run R script for independent features file if it exists
        Rscript ./conditional_entropy_estimation_fixed_hist/run_cde.R "$indep_file" &
    done
done

wait 


for dataset in "${datasets[@]}"; do
    # Loop through permutations
    for perm in "${permutations[@]}"; do
        # Define file names for dependent features
        dep_file="${dataset}_${perm}_dep_features"
        
        echo "Processing dataset: $dataset with number of dep features added: $perm"

        Rscript ./conditional_entropy_estimation_fixed_hist/run_cde.R "$dep_file" & 
    done
done

wait 

##################
##################
datasets=(
    "support2"
    "superconductivity"
    "NavalPropolsion"
)

# Permutations array
permutations=("3" "5" "10" "20")

# Loop through the datasets
for dataset in "${datasets[@]}"; do
    # Loop through permutations
    for perm in "${permutations[@]}"; do
        # Define file names for independent features
        indep_file="${dataset}_${perm}_indep_features"
        
        echo "Processing dataset: $dataset with number of indep features added: $perm"
        
        # Run R script for independent features file if it exists
        Rscript ./conditional_entropy_estimation_fixed_hist/run_cde.R "$indep_file" &
    done
done


for dataset in "${datasets[@]}"; do
    # Loop through permutations
    for perm in "${permutations[@]}"; do
        # Define file names for dependent features
        dep_file="${dataset}_${perm}_dep_features"
        
        echo "Processing dataset: $dataset with number of dep features added: $perm"

        Rscript ./conditional_entropy_estimation_fixed_hist/run_cde.R "$dep_file" & 
    done
done

wait 