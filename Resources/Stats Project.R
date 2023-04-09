library(dplyr)
library(ggplot2)
library(car)
library(caret)
library(scales)
library(tidyr)
library(readr)
library(purrr)
library(forcats)
library(imputeMissings)
install.packages("imputeMissings")
library(tidyverse)
library(leaps)
install.packages("leaps")
library(MASS)
install.packages("olsrr")
library(olsrr)
library(asbio)
install.packages("asbio")
install.packages("tcltk")
library(DAAG)
install.packages("DAAG")

#Import the data 
train = read.csv(file.choose(), sep = ",")
test = read.csv(file.choose(), sep = ",")

#viewing the data 
view(test)
view(train)

#Filtering the Data 
trainNeighborhood <- dplyr:: filter(train, Neighborhood == "Edwards" | Neighborhood == "NAmes" | Neighborhood == "BrkSide")
testNeighborhood <- dplyr:: filter(test, Neighborhood == "Edwards" | Neighborhood == "NAmes" | Neighborhood == "BrkSide")


#Some EDA

#Summary of the data 
summary(train)
summary(test)

#Basic visualizaton of home prices 
trainHist <- ggplot(trainNeighborhood, aes(x = SalePrice)) + geom_histogram(color = "black", fill = "red")
trainHist
#There is normal distribution for the most part, but it is a bit right leaning

#Basic visualization of sq footage
trainBar <- ggplot(trainNeighborhood, aes(x = GrLivArea)) + geom_histogram(color = "black", fill = "red")
trainBar
#This plot is heavily right skewed

#Basic graphs with log transformations 
trainHitLog <-  ggplot(trainNeighborhood, aes(x = log(SalePrice))) + geom_histogram(color = "black", fill = "red")
trainHitLog
# This graph presents normal distribution

trainBarLog <- ggplot(trainNeighborhood, aes(x = log(GrLivArea))) + geom_histogram(color = "black", fill = "red")
trainBarLog
# This graph presents normal distribution

#Testing a scatter plot 
trainScatter <- ggplot(trainNeighborhood, aes(x = log(GrLivArea), y = log(SalePrice), color = Neighborhood)) + geom_point()
trainScatter

#Create an LM with outliers 
priceLM <- lm(log(SalePrice) ~ log(GrLivArea) + Neighborhood + Neighborhood + GrLivArea, data = trainNeighborhood)
summary(priceLM)
confint(priceLM)

#Look at ANOVA
residentANOVA <- aov(log(SalePrice) ~ log(GrLivArea) + Neighborhood + Neighborhood + GrLivArea, data = trainNeighborhood)
summary(residentANOVA)


plot(priceLM)
#There seems to be correlation between home prices and square footage

#model diagnostics and leverage plots
leveragePlots(lm(log(SalePrice) ~ log(GrLivArea) + Neighborhood + Neighborhood + GrLivArea, data = trainNeighborhood))

#Plot Cooks distance
plot(cooks.distance(leveragePlots(lm(log(SalePrice) ~ log(GrLivArea) + Neighborhood + Neighborhood + GrLivArea, data = trainNeighborhood))
)

sort(cooks.distance(leveragePlots(lm(log(SalePrice) ~ log(GrLivArea) + Neighborhood + Neighborhood + GrLivArea, data = trainNeighborhood))
)

#Creating the QQ plot 
qqPlot(log(trainNeighborhood$SalePrice))
#Uneven distribution

#Histogram of Residuals 
trainHist <- hist(priceLM$residuals, breaks = 10, destiny = 10, col = "lightgray", main = "Residuals")
xfit <- seq(min(priceLM$residuals), max(priceLM$residuals), length = 40)
yfit <- dnorm(xfit, mean = mean(priceLM$residuals), sd = sd(priceLM$residuals)) 
yfit <- yfit * diff(h$mids[1:2]) * length(priceLm$residuals) 

#Create lm without outliers 
cleanData <- trainNeighborhood[-c(169, 190, 339)]

priceLM2 <- lm(log(SalePrice) ~ log(GrLivArea) + Neighborhood + Neighborhood + GrLivArea, data = cleanData)
summary(priceLM2)
confint(priceLM2)

#Creat an internal CV
trainIndex <- createDataPartition(trainNeighborhood$SalePrice, p = .8, list = FALSE, times = 1)

trainSale <- trainNeighborhood[ trainIndex,]
testSale <- trainNeighborhood[trainIndex, ]


pred.w.plim <- predict(lm(log(SalePrice)~log(GrLivArea)+Neighborhood+Neighborhood*GrLivArea,data=trainSale), testSale, interval = "prediction")
pred.w.clim <- predict(lm(log(SalePrice)~log(GrLivArea)+Neighborhood+Neighborhood*GrLivArea,data=trainSale), testSale, interval = "confidence")


matplot(testSale$SalePrice, cbind(pred.w.clim, pred.w.plim[,-1]),
        lty = c(1,2,2,3,3), type = "l", ylab = "predicted y")

#predict test data set 
pred.w.plim <- predict(priceLM2, testNeighborhood, interval = "prediction")
view(exp(pred.w.plim))
view(trainNeighborhood$SalePrice)

#Look at ANOVA
res.aov <- aov(log(SalePrice)~log(GrLivArea)+Neighborhood+Neighborhood*GrLivArea, data = cleanData)
summary(res.aov)

#Leverage plots 
leveragePlots(lm(log(SalePrice)~log(GrLivArea)+Neighborhood+Neighborhood*GrLivArea,data=cleanData))

#Model diagnostics, Cook's Distance
plot(cooks.distance(lm(log(SalePrice)~log(GrLivArea)+Neighborhood+Neighborhood*GrLivArea,data=cleanData)))

sort(cooks.distance(lm(log(SalePrice)~log(GrLivArea)+Neighborhood+Neighborhood*GrLivArea,data=cleanData)),decreasing = TRUE)

#Model diagnostics, Quantile-Quantile plot
qqPlot(log(cleanData$SalePrice))

#Hist of residuals
h <- hist(priceLM2$residuals, breaks = 10, density = 10,col = "lightgray",main = "Residuals") 
xfit <- seq(min(priceLM2$residuals), max(priceLM2$residuals), length = 40) 
yfit <- dnorm(xfit, mean = mean(priceLM2$residuals), sd = sd(priceLM2$residuals)) 
yfit <- yfit * diff(h$mids[1:2]) * length(priceLM2$residuals) 

CVdat <- CVlm(data = trainNeighborhood, form.lm = formula(log(SalePrice)~log(GrLivArea)+Neighborhood+Neighborhood*GrLivArea),
              m = 3, dots = FALSE, seed = 29, plotit = c("Observed","Residual"),
              main="Small symbols show cross-validation predicted values",
              legend.pos="topleft", printit = TRUE)
CVdat
(press(priceLm))

#scatterplot matrix
pairs(train2[, c("SalePrice","GrLivArea")],
      main= "Scatterplot Matrix of Variables in Training Set",
      col = "blue")

# List of only the numeric columns
numeric = c("MSSubClass","LotFrontage","OverallQual","OverallCond","YearBuilt",
            "YearRemodAdd","MasVnrArea","BsmtFinSF1", "GarageArea", "WoodDeckSF",
            "OpenPorchSF","EnclosedPorch")

# Create a scatterplot matrix of all numeric columns
pairs(train2analysis[, numeric],
      main = "Scatterplot Matrix of Numeric Variables in train2analysis",
      col = "blue")


### Analysis 2 ####
train2 = read.csv(file.choose(), sep = ",")
test = read.csv(file.choose(), sep = ",")

#Look at outcome variable
ggplot(data = train2 %>% filter(!is.na(log(SalePrice)))) +
  geom_histogram(aes(x = log(SalePrice)), fill = "red", alpha = 1/2, binwidth = 0.01) +
  scale_x_continuous(labels = dollar_format()) +
  labs(
    title = "Outcome Sale Price, right skew"
  ) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 15, face = "bold"), 
  )

#find missing data 
na_prop <- train2 %>% 
  dplyr::select(-SalePrice) %>% 
  map(is.na) %>% 
  map_dfr(mean) %>%
  pivot_longer(cols = everything(), names_to = "variables", values_to = "prop") %>% 
  filter(prop > 0) %>% 
  arrange(desc(prop))

#graphing the data 
na_prop %>%
  ggplot(aes(x = fct_reorder(variables, prop), y = prop, fill = variables)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  theme(legend.position = "none") +
  labs(
    x = "Explanatory variables",
    y = "The proportions of NA values per column"
  ) +
  scale_y_continuous(breaks = seq(0, 1, by = 0.1)) +
  theme(axis.text.y = element_text(size = 10))


train2$PoolQC[is.na(train2$PoolQC)] <- "None"
train2$MiscFeature[is.na(train2$MiscFeature)] <- "None"
train2$Alley[is.na(train2$Alley)] <- "No"
train2$Fence[is.na(train2$Fence)] <- "No"
train2$FireplaceQu[is.na(train2$FireplaceQu)] <- "No"
train2$GarageType[is.na(train2$GarageType)] <- "No"
train2$GarageFinish[is.na(train2$GarageFinish)] <- "No"
train2$GarageQual[is.na(train2$GarageQual)] <- "No"
train2$GarageCond[is.na(train2$GarageCond)] <- "No"
train2$BsmtExposure[is.na(train2$BsmtExposure)] <- "NoBs"
train2$BsmtCond[is.na(train2$BsmtCond)] <- "NoBs"
train2$BsmtQual[is.na(train2$BsmtQual)] <- "NoBs"
train2$BsmtFinType1[is.na(train2$BsmtFinType1)] <- "NoBs"
train2$BsmtFinType2[is.na(train2$BsmtFinType2)] <- "NoBs"

# To specify the levels of ordered factors
PoolQC_lev <- c("None", "Fa", "TA", "Gd", "Ex")
Fence_lev <- c("No", "MnWw", "GdWo", "MnPrv", "GdPrv")
FireplaceQu_lev <- c("No", "Po", "Fa", "TA", "Gd", "Ex")
GarageFinish_lev <- c("No", "Unf", "RFn", "Fin")
GarageQual_lev <- c("No", "Po", "Fa", "TA", "Gd", "Ex")
GarageCond_lev <- c("No", "Po", "Fa", "TA", "Gd", "Ex")
BsmtExposure_lev <- c("NoBs", "No", "Mn", "Av", "Gd")
BsmtCond_lev <- c("NoBs", "Po", "Fa", "TA", "Gd", "Ex")
BsmtQual_lev <- c("NoBs", "Po", "Fa", "TA", "Gd", "Ex")
BsmtFinType1_lev <- c("NoBs", "Unf", "LwQ", "Rec", "BLQ", "ALQ", "GLQ")
BsmtFinType2_lev <- c("NoBs", "Unf", "LwQ", "Rec", "BLQ", "ALQ", "GLQ")

train2analysis <- train2 %>%
  mutate(PoolQC = parse_factor(PoolQC, levels = PoolQC_lev, ordered = TRUE),
         MiscFeature = parse_factor(MiscFeature),
         Alley = parse_factor(Alley),
         Fence = parse_factor(Fence, levels = Fence_lev, ordered = TRUE),
         FireplaceQu = parse_factor(FireplaceQu, levels = FireplaceQu_lev, ordered = TRUE),
         GarageType = parse_factor(GarageType),
         GarageFinish = parse_factor(GarageFinish, levels = GarageFinish_lev, ordered = TRUE),
         GarageQual = parse_factor(GarageQual, levels = GarageQual_lev, ordered = TRUE),
         GarageCond = parse_factor(GarageCond, levels = GarageCond_lev, ordered = TRUE),
         BsmtExposure = parse_factor(BsmtExposure, levels = BsmtExposure_lev, ordered = TRUE),
         BsmtCond = parse_factor(BsmtCond, levels = BsmtCond_lev, ordered = TRUE),
         BsmtQual = parse_factor(BsmtQual, levels = BsmtQual_lev, ordered = TRUE),
         BsmtFinType1 = parse_factor(BsmtFinType1, levels = BsmtFinType1_lev, ordered = TRUE),
         BsmtFinType2 = parse_factor(BsmtFinType2, levels = BsmtFinType2_lev, ordered = TRUE))


#lets impute some data
#Col 4 lot frontage
train2analysis[,4][is.na(train2analysis[,4])] <- round(mean(train2analysis[,4], na.rm = TRUE))

#Col 27, massvnr
train2analysis[,27][is.na(train2analysis[,27])] <- round(mean(train2analysis[,27], na.rm = TRUE))

#Col 60, Garage year built
train2analysis[,60][is.na(train2analysis[,60])] <- round(mean(train2analysis[,60], na.rm = TRUE))

#Col 26, MasVnrType
train2analysis$MasVnrType <- train2analysis$MasVnrType %>% tidyr::replace_na("Stone")

#Col 43, electrical
train2analysis$Electrical <- train2analysis$Electrical %>% tidyr::replace_na("SBrkr ")

train2analysis$GrLivArea <- log(train2analysis$GrLivArea)

sort(is.na(train2analysis),decreasing = TRUE)

train2analysis[!complete.cases(train2analysis),]

################################################################################
#test dat
#Look at missing data
na_prop <- test %>% 
  
  map(is.na) %>% 
  map_dfr(mean) %>%
  pivot_longer(cols = everything(), names_to = "variables", values_to = "prop") %>% 
  filter(prop > 0) %>% 
  arrange(desc(prop))

na_prop %>%
  ggplot(aes(x = fct_reorder(variables, prop), y = prop, fill = variables)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  theme(legend.position = "none") +
  labs(
    x = "Explanatory variables",
    y = "The proportions of NA values per column"
  ) +
  scale_y_continuous(breaks = seq(0, 1, by = 0.1)) +
  theme(axis.text.y = element_text(size = 10))

test$PoolQC[is.na(test$PoolQC)] <- "None"
test$MiscFeature[is.na(test$MiscFeature)] <- "None"
test$Alley[is.na(test$Alley)] <- "No"
test$Fence[is.na(test$Fence)] <- "No"
test$FireplaceQu[is.na(test$FireplaceQu)] <- "No"
test$GarageType[is.na(test$GarageType)] <- "No"
test$GarageFinish[is.na(test$GarageFinish)] <- "No"
test$GarageQual[is.na(test$GarageQual)] <- "No"
test$GarageCond[is.na(test$GarageCond)] <- "No"
test$BsmtExposure[is.na(test$BsmtExposure)] <- "NoBs"
test$BsmtCond[is.na(test$BsmtCond)] <- "NoBs"
test$BsmtQual[is.na(test$BsmtQual)] <- "NoBs"
test$BsmtFinType1[is.na(test$BsmtFinType1)] <- "NoBs"
test$BsmtFinType2[is.na(test$BsmtFinType2)] <- "NoBs"

# To specify the levels of ordered factors
PoolQC_lev <- c("None", "Fa", "TA", "Gd", "Ex")
Fence_lev <- c("No", "MnWw", "GdWo", "MnPrv", "GdPrv")
FireplaceQu_lev <- c("No", "Po", "Fa", "TA", "Gd", "Ex")
GarageFinish_lev <- c("No", "Unf", "RFn", "Fin")
GarageQual_lev <- c("No", "Po", "Fa", "TA", "Gd", "Ex")
GarageCond_lev <- c("No", "Po", "Fa", "TA", "Gd", "Ex")
BsmtExposure_lev <- c("NoBs", "No", "Mn", "Av", "Gd")
BsmtCond_lev <- c("NoBs", "Po", "Fa", "TA", "Gd", "Ex")
BsmtQual_lev <- c("NoBs", "Po", "Fa", "TA", "Gd", "Ex")
BsmtFinType1_lev <- c("NoBs", "Unf", "LwQ", "Rec", "BLQ", "ALQ", "GLQ")
BsmtFinType2_lev <- c("NoBs", "Unf", "LwQ", "Rec", "BLQ", "ALQ", "GLQ")

test2 <- test %>%
  mutate(PoolQC = parse_factor(PoolQC, levels = PoolQC_lev, ordered = TRUE),
         MiscFeature = parse_factor(MiscFeature),
         Alley = parse_factor(Alley),
         Fence = parse_factor(Fence, levels = Fence_lev, ordered = TRUE),
         FireplaceQu = parse_factor(FireplaceQu, levels = FireplaceQu_lev, ordered = TRUE),
         GarageType = parse_factor(GarageType),
         GarageFinish = parse_factor(GarageFinish, levels = GarageFinish_lev, ordered = TRUE),
         GarageQual = parse_factor(GarageQual, levels = GarageQual_lev, ordered = TRUE),
         GarageCond = parse_factor(GarageCond, levels = GarageCond_lev, ordered = TRUE),
         BsmtExposure = parse_factor(BsmtExposure, levels = BsmtExposure_lev, ordered = TRUE),
         BsmtCond = parse_factor(BsmtCond, levels = BsmtCond_lev, ordered = TRUE),
         BsmtQual = parse_factor(BsmtQual, levels = BsmtQual_lev, ordered = TRUE),
         BsmtFinType1 = parse_factor(BsmtFinType1, levels = BsmtFinType1_lev, ordered = TRUE),
         BsmtFinType2 = parse_factor(BsmtFinType2, levels = BsmtFinType2_lev, ordered = TRUE))

#lets impute some data
#Col 4 lot frontage
test2[,4][is.na(test2[,4])] <- round(mean(test2[,4], na.rm = TRUE))

#Col 27, massvnr
test2[,27][is.na(test2[,27])] <- round(mean(test2[,27], na.rm = TRUE))

#Col 60, Garage year built
test2[,60][is.na(test2[,60])] <- round(mean(test2[,60], na.rm = TRUE))

#Col 26, MasVnrType
test2$MasVnrType <- test2$MasVnrType %>% tidyr::replace_na("Stone")

#Col 43, electrical
test2$Electrical <- test2$Electrical %>% tidyr::replace_na("SBrkr ")
test2$GrLivArea <- log(test2$GrLivArea)


#Building Models

#Full model
full.model <- lm(log(SalePrice)~.,data = train2analysis)

#Stepwise model
step.model <- stepAIC(full.model,direction = "both",trace = FALSE)

#Model summary 
step.model$pred

models <- regsubsets(log(SalePrice)~., data = train2analysis, nvmax = 1,
                     method = "seqrep")

summary(models)

set.seed(123)
# Set up repeated k-fold cross-validation
train.control <- trainControl(method = "cv", number = 10)
# Train the model
step.model <- train(log(SalePrice) ~., data = train2analysis,
                    method = "leapBackward", 
                    tuneGrid = data.frame(nvmax = 1:75),
                    trControl = train.control
)

step.model$results

step.model$bestTune

stepLm <- lm(log(SalePrice)~OverallQual+OverallCond+YearBuilt+BsmtFinType2+KitchenAbvGr+GarageCond,data = train2analysis)
summary(stepLm)
summary(step.model$finalModel)
coef(step.model$finalModel, 6)
press(stepLm)
plot(stepLm)

#Model diagnostics, leverage plots
leveragePlots(stepLm,data=train2analysis)

#Model diagnostics, Cook's Distance
plot(cooks.distance(stepLm,data=train2analysis))


###############
min.model = lm(log(SalePrice) ~ 1, data=train2analysis)
biggest <- formula(lm(log(SalePrice)~.,train2analysis))
biggest

fwd.model = step(min.model, direction='forward', scope=biggest)

summary(fwd.model)

forwardlm <- lm(log(SalePrice)~GrLivArea+Neighborhood+GarageCars+OverallCond+HouseStyle+YearBuilt+RoofMatl+BsmtFinSF1+MSZoning+Functional+Condition1+SaleCondition+KitchenQual+LotArea+Condition1+Exterior1st+ScreenPorch+Heating+LandSlope+WoodDeckSF+TotalBsmtSF+LotConfig+CentralAir+GarageQual+BsmtFullBath+Fireplaces+X2ndFlrSF+YearRemodAdd+GarageArea+Foundation+LotFrontage+KitchenAbvGr+GarageCond+SaleType+ExterCond+Street+HalfBath,data = train2analysis)

summary(forwardlm)
plot(forwardlm)

#Model diagnostics, leverage plots
leveragePlots(forwardlm,data=train2analysis)

#Model diagnostics, Cook's Distance
plot(cooks.distance(forwardlm,data=train2analysis))

#predict test data set
forward.lm.plim <- predict(forwardlm, test2, interval = "prediction")

####Write forward model
forward.lm.plim <- forward.lm.plim[,1]
forward.lm.plim <- as.data.frame(forward.lm.plim)
forward.lm.plim <- exp(forward.lm.plim[,1])
forward.lm.plim <- forward.lm.plim %>% rename(SalePrice = forward.lm.plim,)
forward.lm.plim[,1][is.na(forward.lm.plim[,1])] <- round(mean(forward.lm.plim[,1], na.rm = TRUE))
out <- write.csv(forward.lm.plim,"forwardModel.csv")


####Write Step model
stepWise.lm.plim <- predict(step.model, test2, interval = "prediction")
stepWise.lm.plim <- exp(stepWise.lm.plim)
stepWise.lm.plim <- as.data.frame(stepWise.lm.plim)
stepWise.lm.plim <- stepWise.lm.plim %>% rename(SalePrice = stepWise.lm.plim,)
stepWise.lm.plim$ID <- seq.int(nrow(stepWise.lm.plim))
outStepwise <- write.csv(stepWise.lm.plim,"stepwiseModel.csv")
View(stepWise.lm.plim)

# Set seed for reproducibility
set.seed(123)

# Set up repeated k-fold cross-validation
train.control <- trainControl(method = "cv", number = 10)

# Train the model
step.model <- train(log(SalePrice) ~., data = train2analysis,
                    method = "leapBackward", 
                    tuneGrid = data.frame(nvmax = 1:10),
                    trControl = train.control
)
step.model$results
summary(step.model$finalModel)
coef(step.model$finalModel, 7)

backlm <- lm(log(SalePrice)~OverallQual+OverallCond+YearBuilt+RoofMatl+BsmtFinType2+KitchenAbvGr+GarageCond,data = train2analysis)
summary(backlm)

#predict test data set
back.lm.plim <- predict(backlm, test2, interval = "prediction")
back.lm.plim <- back.lm.plim[,1]
back.lm.plim <- exp(back.lm.plim)
back.lm.plim <- as.data.frame(back.lm.plim)
back.lm.plim <- back.lm.plim %>% rename(SalePrice = back.lm.plim,)
back.lm.plim$ID <- seq.int(nrow(back.lm.plim))
outBack <- write.csv(backModel,"backModel1.csv")