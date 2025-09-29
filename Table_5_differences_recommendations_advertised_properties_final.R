# ---------------------------------------------------------------------------------------------- #
#   Generate Table 5. Differences in Recommendations and Availability of Advertised Properties   #
#                                                                                                #
#   R-Version: 4.04                                                                              #                                                             #
#   Date Last Modification: 12/01/2021                                                           #
# -----------------------------------------------------------------------------------------------#

# Clear workspace

# rm(list = ls())

# Set working directory

# setwd("~/")

# Define function for loading packages
pkgTest <- function(x) {
  if (!require(x, character.only = TRUE)) {
    install.packages(x, dep = TRUE)
    if (!require(x, character.only = TRUE)) stop("Package not found")
  }
}

# Load packages
packages <- c("readxl", "readstata13", "lfe", "Synth", "data.table", "plm", "ggplot2", "MatchIt", "experiment", "stargazer", "dplyr")
lapply(packages, pkgTest)


# Output directory

# out <- "~/"

## Housing Search  ######################################################################################################

# Preamble

# Unless Otherwise Specified, Model Sequence is as follows:
# Model 1: treatment effect conditional on advertisement price
# Model 2: treatment effect also conditional on level of treatment outcome in advertised listing
# Model 3: treatment effect also conditional on racial composition of block group of advertised listing
# Model 4: treatment effect also conditional on racial composition of block group of recommended listing
# Model 5: treatment effect also conditional on price of recommended home

# Load data

recs_trial_final <- readRDS(paste0(in_dir, "adsprocessed_JPE.rds"))

# construct separate indicators for market and control

recs_trial_final$market <- as.factor(sapply(strsplit(as.character(recs_trial_final$CONTROL), "-"), `[`, 1))
recs_trial_final$CONTROL <- as.factor(recs_trial_final$CONTROL)

recs_trial_final$show <- recs_trial_final$STOTUNIT
recs_trial_final$show[recs_trial_final$STOTUNIT < 0] <- NA

# construct indicators for race groups
recs_trial_final$ofcolor <- NA_integer_
recs_trial_final$ofcolor[recs_trial_final$APRACE == 1] <- 0  # White
recs_trial_final$ofcolor[recs_trial_final$APRACE %in% c(2,3,4)] <- 1  # AA, Hisp/Latinx, Asian
recs_trial_final$ofcolor <- factor(recs_trial_final$ofcolor, levels=c(0,1),
                                   labels=c("White","Racial minority"))

recs_trial_final <- subset(recs_trial_final, APRACE %in% c(1,2,3,4))
recs_trial_final$APRACE <- factor(recs_trial_final$APRACE,
                                  levels=c(1,2,3,4),
                                  labels=c("White","African American","Hispanic/Latinx","Asian"))
recs_trial_final$APRACE <- relevel(recs_trial_final$APRACE, ref="White")


# show distinct value of HCITY
unique(recs_trial_final$HCITY)
# show distinct value of HCITY  starting with Al or AL
unique(recs_trial_final$HCITY[grepl("^ALB", recs_trial_final$HCITY, ignore.case = TRUE)])

library(stringr)

recs_trial_final <- recs_trial_final %>%
  mutate(HCITY_raw = HCITY) %>%
  mutate(HCITY = str_to_lower(HCITY)) %>%
  mutate(
    HCITY = str_replace_all(HCITY, "[[:punct:]]", " "),
    HCITY = str_squish(HCITY),
    HCITY = na_if(HCITY, "")
  ) %>%
  mutate(HCITY = factor(HCITY))
# Race
# cross-tabulate APRACE and ofcolor in recs_trial_final
table(recs_trial_final$APRACE, recs_trial_final$ofcolor)

# re-tabulate
table(recs_trial_final$APRACE, recs_trial_final$ofcolor)


# Dicrimination and Showings
# STEERING AND white NEIGHBORHOOD

SHOW1 <- felm(show ~ ofcolor | CONTROL + SEQUENCE.x + month + market + ARELATE2 + HHMTYPE + SAPPTAM + TSEX.x + THHEGAI + TPEGAI + THIGHEDU + TCURTENR + ALGNCUR + AELNG1 + DPMTEXP + AMOVERS + age + ALEASETP + ACAROWN | 0 | CONTROL, data = recs_trial_final)
SHOW3 <- felm(show ~ ofcolor + w2012pc_Ad + b2012pc_Ad + a2012pc_Ad + hisp2012pc_Ad + logAdPrice | CONTROL + SEQUENCE.x + month + market + ARELATE2 + HHMTYPE + SAPPTAM + TSEX.x + THHEGAI + TPEGAI + THIGHEDU + TCURTENR + ALGNCUR + AELNG1 + DPMTEXP + AMOVERS + age + ALEASETP + ACAROWN | 0 | CONTROL, data = recs_trial_final)

SHOW1_ <- felm(show ~ APRACE | CONTROL + SEQUENCE.x + month + market + ARELATE2 + HHMTYPE + SAPPTAM + TSEX.x + THHEGAI + TPEGAI + THIGHEDU + TCURTENR + ALGNCUR + AELNG1 + DPMTEXP + AMOVERS + age + ALEASETP + ACAROWN | 0 | CONTROL, data = recs_trial_final)
SHOW3_ <- felm(show ~ APRACE + w2012pc_Ad + b2012pc_Ad + a2012pc_Ad + hisp2012pc_Ad + logAdPrice | CONTROL + SEQUENCE.x + month + market + ARELATE2 + HHMTYPE + SAPPTAM + TSEX.x + THHEGAI + TPEGAI + THIGHEDU + TCURTENR + ALGNCUR + AELNG1 + DPMTEXP + AMOVERS + age + ALEASETP + ACAROWN | 0 | CONTROL, data = recs_trial_final)


##########################################################################################################################################################################

# STEERING

recs_trial_final$home_av <- recs_trial_final$SAVLBAD
recs_trial_final$home_av[recs_trial_final$home_av < 0] <- NA
recs_trial_final$home_av[recs_trial_final$home_av > 1] <- 0

SHOWad1 <- felm(home_av ~ ofcolor | CONTROL + SEQUENCE.x + month + market + ARELATE2 + HHMTYPE + SAPPTAM + TSEX.x + THHEGAI + TPEGAI + THIGHEDU + TCURTENR + ALGNCUR + AELNG1 + DPMTEXP + AMOVERS + age + ALEASETP + ACAROWN | 0 | CONTROL, data = recs_trial_final)
SHOWad3 <- felm(home_av ~ ofcolor + w2012pc_Ad + b2012pc_Ad + a2012pc_Ad + hisp2012pc_Ad + logAdPrice | CONTROL + SEQUENCE.x + month + market + ARELATE2 + HHMTYPE + SAPPTAM + TSEX.x + THHEGAI + TPEGAI + THIGHEDU + TCURTENR + ALGNCUR + AELNG1 + DPMTEXP + AMOVERS + age + ALEASETP + ACAROWN | 0 | CONTROL, data = recs_trial_final)

SHOWad1_ <- felm(home_av ~ APRACE | CONTROL + SEQUENCE.x + month + market + ARELATE2 + HHMTYPE + SAPPTAM + TSEX.x + THHEGAI + TPEGAI + THIGHEDU + TCURTENR + ALGNCUR + AELNG1 + DPMTEXP + AMOVERS + age + ALEASETP + ACAROWN | 0 | CONTROL, data = recs_trial_final)
SHOWad3_ <- felm(home_av ~ APRACE + w2012pc_Ad + b2012pc_Ad + a2012pc_Ad + hisp2012pc_Ad + logAdPrice | CONTROL + SEQUENCE.x + month + market + ARELATE2 + HHMTYPE + SAPPTAM + TSEX.x + THHEGAI + TPEGAI + THIGHEDU + TCURTENR + ALGNCUR + AELNG1 + DPMTEXP + AMOVERS + age + ALEASETP + ACAROWN | 0 | CONTROL, data = recs_trial_final)

### GENERATE TABLES
# out <- "C:/Users/genin/OneDrive/Documents/Git/Discrimination/output/"

########### Control Group Mean####################

stargazer(SHOW1, SHOW3, SHOWad1, SHOWad3,
  type = "latex",
  out = paste0(out, "HUM_tab5_JPE.tex"),
  title = "Steering and Neighborhood Effects",
  model.numbers = F,
  keep = c("ofcolor"),
  covariate.labels = c("Racial Minority"),
  keep.stat = c("n", "adj.rsq"),
  digits = 4, digits.extra = 0, no.space = T, align = T, model.names = F, notes.append = T, object.names = F,
  add.lines = list(
    c("ln(Price) Advert Home", "N", "Y", "N", "Y"),
    c("Racial Comp Advert Home", "N", "Y", "N", "Y")
  )
)


stargazer(SHOW1_, SHOW3_, SHOWad1_, SHOWad3_,
          type = "latex",
          out = paste0(out, "HUM_tab5_JPE_.tex"),
          title = "Steering and Neighborhood Effects",
          dep.var.labels.include = FALSE,
          column.labels = c("Number of Recommendations", "Home Availability"),
          column.separate = c(2, 2),                 # 2+2 columns
          model.numbers = FALSE,
          keep = c("APRACE"),                        # keeps all non-reference APRACE dummies
          covariate.labels = c("African American", "Hispanic/Latinx", "Asian"),  # 3 labels
          keep.stat = c("n", "adj.rsq"),
          digits = 4, digits.extra = 0, no.space = TRUE, align = TRUE,
          model.names = FALSE, notes.append = TRUE,
          add.lines = list(
            c("ln(Price) Advert Home", "N", "Y", "N", "Y"),
            c("Racial Comp Advert Home", "N", "Y", "N", "Y")
          )
)
