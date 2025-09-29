# Reproducing a paper
## Paper for this exercise


- Christensen, Peter, and Christopher Timmins. 2022. "Sorting or Steering: The Effects of Housing Discrimination on Neighborhood Choice." Journal of Political Economy, 130 (8): 2110–2163. https://doi.org/10.1086/720140.

  - [Paper](https://www.journals.uchicago.edu/doi/full/10.1086/720140)
  - [Online Appendix repository](https://www.journals.uchicago.edu/doi/suppl/10.1086/720140/suppl_file/20191181Appendix.pdf)
  - [Data and R code](https://www.journals.uchicago.edu/doi/suppl/10.1086/720140/suppl_file/20191181data.zip)
 
  
## Overall goal
- The overall task is to replicate all exhibits from the paper other than the Appendix tables. We are also not going to replicate Figures 1 and 2 becasue they are maps and require Google API for production. 
- This is a JPE paper from 2022 with non-minor replicability issues.
  - The exercise will show you how failing to adhere to best reproducibility practices leads to an unnecessarily strenuous replication process. 
  - All exhibits are perfectly reproducible after making the right changes and adhering to the authors' data and coding assumptions. You will be asked to evaluate some of these assumptions, propose changes, and see if the results change. 
- This is the original reproducibility package downloaded from the Journals UChicago repository. 

# Exercises
- The full replication involves replicating Tables 1-14 and Appendix Figure B1. All of the below exercises expect replication of and only of these exhibits. Production of these exhibits takes 20 minutes to run on 16 GB Apple M2. 

## Exercise 1: Set up (5%)
Edit the code so that it works on your computer. This includes:
1. Create a `master.R` script which:
   1. Sets your workding directory and sets file paths.
   2. Creates a list of scripts to run.
   3. (Optional) Contains error handling that informs you if a file does not exist. Contains messages that inform you when a script starts and stops running.
> You may need to edit the original scripts to omit deleting the whole environment, re-defining paths, edit paths for output, and create a folder for the output. 
2. Installing packages
   1. The current repkit does not specify versioning of R packages. To learn more about using R packages reproducibly, please look [here](https://rviews.rstudio.com/2018/01/18/package-management-for-reproducible-r-code/) and [here](https://cran.r-project.org/web/packages/checkpoint/vignettes/checkpoint.html).

       
## Exercise 2: Bug fixes (5%)
This code includes some bugs. Creating [issues](https://github.com/cejka-melo/coding_task/issues) to identify bugs and share solutions will help you get through this part of the exercise faster.

- Common mistakes may include:
   1. errors in saving exhibits
   2. manipulation of redundant objects
   3. typos in calling objects
   4. assigning incorrect classes to objects
- If you find a bug, remember to document it as an issue as it may occur again.


## Exercise 3: Reproducibility (5%)
Once you are able to run the full code, check if the outputs match the paper and if outputs are stable.
1. Run the full code once and commit any changes.
2. Compare output to the paper.
   1. Do you find the exhibit names useful for finding the paper exhibits to which they correspond? If not, what changes would you make?
3. Re-run the whole codebase and look at the `git diff` to identify any instabilities in the outputs.
4. Does the repkit contain a `.tex` file for the paper? Why would that be useful?
5. Does the formatting of the output match the formatting in the paper? If not, what does that imply for paper production in terms of manual work?

## Exercise 4: Robustness (85%)
1. Understand Table 5 in the paper.
2. Which coefficients are statistically significant in Table 5 of the paper and in the `.tex` versions of this table that you've reproduced?
3. Fixed effects.
   1. How many different sets of fixed effects does the regression specification use? How useful do you find the variable names in this script?
   2. How many distinct values does the variable for city (`HCITY`) have? Do you consider this variable high-quality?
   4. Standardize casing and remove all punctuation for variable `HCITY`, then re-run Table 5.
   5. Explain what, if anything, changed with this update in terms of point estimates, inference, and interpretation of Table 5. Explain why.
4. Race.
   1. Familiarize yourself with Table 1 and page 2125 of the paper to understand how the different race indicator variables are defined.
   2. Looking back at Table 5 in the paper, describe which races should be included in "Racial minority" and the Omitted (Reference) Category.
   3. Examining the script for Table 5 describe describe which races are included in "Racial minority" and the Omitted (Reference) Category.
   > The code that saves the table correctly labels the values of the `APRACE` variable. You are given this hint because the repkit does not include a `README` file, documentation for the datasets, or raw datasets.
   5. If your answers to questions (ii) and (iii) differ, explain how exactly and which categorization is preferable.
   6. Suggest a change for how the race variables are coded in Table 5 and re-run the script.
   7. Explain what, if anything, changed with this update in terms of point estimates, inference, and interpretation of Table 5. Explain why.
5. Fixed effects and Race.
   1. Re-run your script with the changes you've made in parts 3 and 4 of this question.
   2. Explain what, if anything, changed with this update in terms of point estimates, inference, and interpretation of Table 5. Explain why.
  
## Exercise 5: Automation
1. List the tasks that are necessary to update Table 5 in the paper (i.e., the `pdf`) with the changes from Exercise 4 using the original repkit and estimate how long it would take you.

## Exercise 6: Ease of use
How easy is it to compile the paper itself once the code runs?
1. You decided to exclude city fixed effects from your specifications for Table 5 in light of Exercise 4. Re-create Table 5 without city fixed effects.
2. Look at the `git diff` to count how many lines of code you needed to change to achieve this fully.
3. You decided to exclude city fixed effects from all specifications in the paper. Estimate how many lines of code this change would require (no need to perform this).
4. Can you think of a way to re-structure the code so that such changes would be easier? (If you've already done this above, great!)


## Exercise 7: Testing
How can you build checks into the code to prevent the complications in Exercise 4?
1. Recall the two operations performed in the code that led to complications encountered in Exercise 4 and identify two other operations performed in the code that are "risky". Create issues pointing to the lines of code that perform these operations.
> For example, operations that change the number of observations in the data, combine different datasets, aggregate data points, or that may be sensitive to the presence of missing values.
2. Discuss with your group how to build checks into the code to prevent errors from being introduced when these operations are performed.
> Two particularly useful commands here are `assert` and `table`. 









           
