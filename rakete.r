# Installing and loading packages readODS for loading the needed file,
#     and mice for Predictive Mean Matching imputation of missing values.
install.packages("readODS")
install.packages("mice")   
install.packages("caret")
install.packages("Metrics")
install.packages("glmnet")
install.packages("ROSE")
library("readODS")
library("mice")
library("caret")
library("Metrics") 
library("glmnet")
library("ROSE")

# Using readODS to load the file and putting it into Data Frame.
rocket_data <- read_ods("144-rakete.ods")
rocket_data_frame <- data.frame(data)


# Imputing the missing values using mice package's Predictive Mean Matching method.
data_imp <- complete(mice(rocket_data_frame, m = 1, method = "pmm"))


# Lets exclude Russian and NATO reporting names from dataset, as they are 
# irrelevant to missile's range, which is what we are predicting now.
# data_frp stands for data for range prediction.
# data_imp[,"tip_goriva"] <- as.numeric(as.factor(data_imp[ ,"tip_goriva"]))-1
data_nn <- data_imp[ ,-c(1,2)]

data_frp <- data_nn[,-7] 

data_target <- data_nn[ ,7]

# Splitting the data in training and testing parts.
# Cross-validation may be better option here thought, as there is not many rows of data.
set.seed(100)
data_frp_train_indices <- createDataPartition(data_target, p=0.8, list=FALSE)

data_frp_train <- data_frp[data_frp_train_indices, ]
data_frp_test <- data_frp[-data_frp_train_indices, ]

data_target_train <- data_target[data_frp_train_indices]
data_target_test <- data_target[-data_frp_train_indices]

# Training the model.
model <- lm(data_target_train ~ ., data = data_frp_train)

summary(model)

# Deploying the model
prediction_range_lm <- predict(model, newdata=data_frp_test)

# Calculating the Mean Absolute Error
mae(data_target_test, prediction_range_lm)


# Using Lasso Regression

##########################################
#                 TO DO                  #
##########################################




# Making the classifier that predicts if the missile has mobile or fixed launcher.

data_glm <- data_imp

data_imp[ , "tip_goriva"] <- as.numeric(as.factor(data_imp[ , "tip_goriva"]))-1

data_glm<-data_glm[ ,-c(1,2)]

target_glm <- data_glm$nacin_lansiranja
launcher <- c()

for(i in 1:39){
  if(target_glm[i]=="Silos"){
    launcher[i]=0
  }else{
    launcher[i]=1
  }
}
launcher

dummy <- model.matrix(~ klasa_po_dometu - 1, data =data_glm)
data_glm<-data_glm[, -10]
data_glm<-cbind(data_glm, dummy)

View(data_glm)

dummy2 <- model.matrix(~ nacin_lansiranja - 1, data = data_glm)
data_glm<-data_glm[, -8]
data_glm<-cbind(data_glm, dummy2)

View(data_glm)

colnames(data_glm)[colnames(data_glm) == "nacin_lansiranjaAvion"] <- "Avion"
colnames(data_glm)[colnames(data_glm) == "nacin_lansiranjaSilos"] <- "Silos"
colnames(data_glm)[colnames(data_glm) == "nacin_lansiranjaRM TEL"] <- "RMTEL"
colnames(data_glm)[colnames(data_glm) == "nacin_lansiranjaMornaricki"] <- "Mornaricki"

colnames(data_glm)[colnames(data_glm) == "klasa_po_dometuS"] <- "klasaS"
colnames(data_glm)[colnames(data_glm) == "klasa_po_dometuM"] <- "klasaM"
colnames(data_glm)[colnames(data_glm) == "klasa_po_dometuL"] <- "klasaL"

target_glm<- data_glm["Silos"]

data_glm<-data_glm[,-c(12,13,14,15)]
set.seed(100)
train_indices<-createDataPartition(launcher, p=0.8, list=FALSE)

train_glm <- data_glm[train_indices,]
test_glm <- data_glm[-train_indices,]

target_glm_train <- target_glm[train_indices]
target_glm_test <- target_glm[-train_indices]


train_glm["target"] <- target_glm_train


over <- ovun.sample(data_target~., data =train_glm, method = "over", p=0.5)["data"]
table(over$target_glm)


train_glm <- over[,-12]
target_glm_train <- over[,12]


means <- colMeans(train_glm)
stds <- apply(train_glm,2, sd)
train_scaled <- scale(train_glm, center = means, scale = stds)
test_scaled <- scale(test_glm, center = means, scale = stds)


model_knn <- knn(train_scaled, test_scaled, cl = train_glm_train, k=9,prob = TRUE )
predicted_knn <-attributes(model_knn)$prob
predicted_knn <- (2*(model_knn == 1) - 1)*predicted_proba_9 + (model_knn == 0)*1

target_prediction <-as.numeric(predicted_proba_9 > 0.5)

target_prediction
train_glm_test


roc_curve <- roc(response = target_glm_test, predictor = target_prediction)
plot(roc_curve)
auc(roc_curve)



# Let's get rid of missiles with class M.




##########################################
#                 TO DO                  #
##########################################


# 
