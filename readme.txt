I. INSTALLATION: 

Requirements: 
- R version 4.3.3
- R package SCCI, which requires Rcpp >= 0.12.13

For only testing the code, we recommend running the code in the RStudio. 

Note: We find that using the Conda virtual environment may cause compiling errors when installing Rcpp and SCCI, but here is what works for me in the end when I was testing my code: 

1. My Conda version is conda 23.1.0

2. Create a Anaconda environment by the command line "conda create --name cdtree r-essentials r-base" (you can replace "cdtree" with any name you like; also in Step 3).

3. Activate the virtual environment, by "conda activate cdtree" 

4. Enter R by typing "R" in the command line AFTER ACTIVATING the virtual environment. 

5. Type "  install.packages('SCCI')  " in the R console. 


We encountered compiling error when 1) the r-essentials are not installed, 2) the R version is 3.6, or 3) using "conda install ..." to install "Rcpp" and "SCCI"


II. RUN THE EXPERIMENTS

1. Use command line tools to navigate to the root folder CDTree;

2. Install the required packages (see above);

3. To test if the code works now, use

"Rscript conditional_entropy_estimation_fixed_hist/run_cde.R", 

Which will run the code on a small dataset and the results can be obtained within a few seconds. 

4. For getting the results in Table 2 and Figure 2, use 

"Rscript conditional_entropy_estimation_fixed_hist/run_cde.R DATA_NAME" and change the DATA_NAME to the specific data name, among

[ NavalPropolsion	
  energy		
  sml2010		
  synchronous
  SkillCraft		
  forestfires	
  studentmath	
  toxicity
  Thermography	
  localization	
  superconductivity
  concrete	
  slump		
  support2 ]

5. For getting the results of CDTree in Table Figure 3, 4, 5: use 

"Rscript conditional_entropy_estimation_fixed_hist/run_cde_scalability.R DATA_NAME", in which all datasets are in the folder 
"./conditional_entropy_estimation_fixed_hist/permuted_dataset_noiseadded_addingFeature"


6. We use a bash script to run all datasets in parallel. See "run_cde.sh" and "run_cde_scala.sh"; 






