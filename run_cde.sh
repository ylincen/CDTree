#!/bin/bash

# Array of data file names
files=(
    "NavalPropolsion"
    "forestfires"
    "superconductivity"
    "concrete"
    "localization"
    "synchronous"
    "energy"
    "slump"
    "toxicity"
    "SkillCraft"
    "support2"
    "Thermography"
    "studentmath"
    "sml2010"
)

# Loop through the files and run the R script in parallel
for file in "${files[@]}"; do
    Rscript ./conditional_entropy_estimation_fixed_hist/run_cde.R "$file" &
done

# Wait for all background processes to finish
wait

