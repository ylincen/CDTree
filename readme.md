# CDTree: Conditional Entropy Estimation and Experiments

## I. About
This is the original implementation of **CDTree**, a decision-tree-based model that can be used for **conditional density estimation (CDE)**, which was proposed in the paper **Yang, L & van Leeuwen, M Conditional Density Estimation with Histogram Trees. In: Proceedings of the Conference on Neural Information Processing Systems (NeurIPS 2024), 2024.**

The resulting model is fully interpretable and the training process does NOT require hyperparameter tuning (e.g., no need to tune the coefficient for regularization), as the learning criterion is designed based on the MDL principle. 


## II. Installation

### Requirements
- **R** version 4.3.3
- **R Packages**: 
  - `SCCI`, which requires `Rcpp` >= 0.12.13

### Recommended Setup

For testing the code, we recommend using **RStudio**. Please note that using Conda virtual environments may cause compilation errors when installing `Rcpp` and `SCCI`. Here's what worked during testing:

### Step-by-Step Guide

1. **Conda Version**: Ensure you have `conda` version 23.1.0.
2. **Create Environment**: Run the following command to create a Conda environment (you can replace `cdtree` with any name):
   ```bash
   conda create --name cdtree r-essentials r-base
3. **Activate Environment**: Activate the environment using:
   ```bash
   conda activate cdtree
4. **Open the R console**: After activating the environment, enter R:
   ```bash
   R
6. **Install Required Packages**: In the R console, install SCCI
   ```bash
   install.packages('SCCI')

## III. Running Experiments

### Steps
1. **Navigate to Root Folder**: Use terminal to navigate to the root folder CDTree.
2. **Install Required Packages**: Follow the instructions in the Installation section above.
3. **Test Code on a Small Dataset**: 
   ```bash
   Rscript conditional_entropy_estimation_fixed_hist/run_cde.R
   ```
   This will run the code on a small dataset for testing. The results can be obtained within a few seconds.
4. **Reproduce Results in the paper (Table 2 and Figure 2)**. To run the experiments on specific datasets, use:
    ```bash
    Rscript conditional_entropy_estimation_fixed_hist/run_cde.R DATA_NAME
    ```

    Replace DATA_NAME with one of the following:
    ```bash
    NavalPropolsion, energy, sml2010, synchronous, SkillCraft, forestfires,
    studentmath, toxicity, Thermography, localization,
    superconductivity, concrete, slump, support2
    ```
5. **Reproduce Results in the paper (Figure 3, 4, 5)**. To get results in Figures 3, 4, and 5, use:
    ```bash
    Rscript conditional_entropy_estimation_fixed_hist/run_cde_scalability.R DATA_NAME
    ```
    The datasets are located in the folder:
    ```bash
    ./conditional_entropy_estimation_fixed_hist/permuted_dataset_noiseadded_addingFeature
    ```
6. **Run Experiments in Parallel:** You can run all datasets in parallel using the provided bash scripts:
    - run_cde.sh
    - run_cde_scala.sh



   


