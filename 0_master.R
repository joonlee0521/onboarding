# Master script running all the scripts in the repkit
rm(list = ls())
pkgTest <- function(x) {
  if (!require(x, character.only = TRUE)) {
    install.packages(x, dep = TRUE)
    if (!require(x, character.only = TRUE)) stop("Package not found")
  }
}
packages <- c(
  "caret", "dplyr", "stargazer", "readxl", "readstata13", 
  "lfe", "Synth", "data.table", "plm", "ggplot2", 
  "MatchIt", "experiment", "stringr", "foreign", "Hmisc"
)
lapply(packages, pkgTest)

# Set directories
home_dir <- "/Users/hyungjoonlee/Downloads/coding_task-main/" # CHANGE IF NEEDED
in_dir <- paste0(home_dir, "Final Data Sets/")
out <- paste0(home_dir, "out/")
figures_dir <- paste0(home_dir, "Figures/")
appendix_dir <- paste0(home_dir, "Appendix/")

# List of R scripts in the main directory (Final Data Sets)
main_scripts <- c(
    "Table_1_Descriptive_statistics_for_testers_final.R",
    "Table_2_Home_and_Neighborhood_characteristics_final.R",
    "Table_3_Balance_Statistics_for_Testers.R",
    "Table_4_Balance_Statistics_For_Homes_final.R",
    "Table_5_differences_recommendations_advertised_properties_final.R",
    "Table_6_discriminatory_steering_racial_composition_final.R",
    "Table_7_discriminatory_steering_racial_income_final.R",
    "Table_8_discriminatory_steering_neighborhood_effects_final.R",
    "Table_9_discriminatory_steering_Polution_final.R",
    "Table_10_mothers_final.R",
    "Table_11_low_poverty_neighborhoods_final.R",
    "Table_12_median_income_neighborhood_final.R",
    "Table_13_implied_preferences_neighborhood_attributes_final.R",
    "Table_14_price_later_transactions.R"
)

# X   "Table_8_names.R" => not in paper  or appendix
# X TO DO Table_11_low_poverty_neighborhoods_final.R - fix saving stargazer
# X FIXED Table_14_price_later_transactions.R recs_trial_final$CONTROL issue
# OMIT  API "Figure_1_Market_in_2012_HUD_Buyer.R",
# OMIT  API "Figure_2_Trial_Maps_Chicago_and_Angeles.R",
# X TO DO Table_E1_controls.R" same issue

# List of R scripts in Figures
figures_scripts <- c(
    "Figure_B1_white_share_income_and_neighborhood_characteristics.R"
)

# Omitting "Figure_1_Market_in_2012_HUD_Buyer.R" and "Figure_2_Trial_Maps_Chicago_and_Angeles.R"

# Maybe Appendix too

# List of R scripts in Appendix
# appendix_scripts <- c(
#     "Table_C_1_Appendix_american_steering.R",
#     "Table_C_2_Appendix_n_income_steering.R",
#     "Table_C_3_Appendix_Hispanic_steering.R",
#     "Table_C_4_Appendix_ic_income_steering.R",
#     "Table_C_5_Appendix_Asian_steering.R",
#     "Table_C_6_appendix_an_income_steering.R",
#     "Table_D2_Differentiaring_White_Share.R",
#     "Table_E1_controls.R",
#     "Table_E2_test_of_sq...rences_from_mean.R",
#     "Table_F1_Price.R",
#     "Table_G1_Final.R",
#     "Table_G2_Above_Median_Price_Final.R",
#     "Table_H_1.R"
# )
appendix_scripts <- c()

# Function to run scripts from a given directory
run_scripts <- function(script_list, script_dir) {
    for (script in script_list) {
        script_path <- file.path(script_dir, script)

        if (file.exists(script_path)) {
            message(paste("Running:", script))
            source(script_path, echo = TRUE) # echo = TRUE prints commands as they run
            message(paste("Finished:", script, "\n"))
        } else {
            warning(paste("File not found:", script))
        }
    }
}

# Run scripts in order
run_scripts(main_scripts, home_dir)
run_scripts(figures_scripts, figures_dir)
run_scripts(appendix_scripts, appendix_dir)

message("All scripts executed successfully!")

