# Installing and loading packages readODS for loading the needed file,
#     and mice for Predictive Mean Matching imputation of missing values.
install.packages("readODS")
install.packages("mice")                                      
library("readODS")
library("mice")

# Using readODS to load the file and putting it into Data Frame.
rocket_data <- read_ods("144-rakete.ods")
rocket_data_frame <- data.frame(data)


# Imputing the missing values using mice package's Predictive Mean Matching method.
data_imp <- complete(mice(rocket_data_frame, m = 1, method = "pmm"))
