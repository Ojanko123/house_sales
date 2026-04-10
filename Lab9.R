
# Problem 1
 
 
#Data management
 
price=c(22,43,94,97,102,100,108,116,127,124,128,140,147,150,157,161,163,167,172,187,190,192,198,200,199,203,206,209,216,220,219,228,242,239,246,242,251,253,252,257,268,267,269,308,310,315,341,339,345,384)
age=c(20,17,15,16,16,12,14,11,14,12,11,12,11,13,14,12,11,12,9,14,12,8,10,8,9,15,10,9,10,7,10,12,6,9,7,9,6,10,11,9,8,7,7,8,7,8,5,7,8,3)
distance=c(2179.20,2037.31,1958.00,2127.46,2050.94,2118.53,1881.12,2217.83,2542.82,2318.64,2400.16,2662.59,1520.63,1174.14,1090.54,1405.14,1145.74,1516.11,1119.62,1485.95,1442.10,1828.04,1855.47,1415.84,1756.92,1974.66,2075.34,2222.04,1836.08,2167.76,2030.01,2261.58,2431.54,2407.86,2701.02,756.35,785.57,806.42,2082.34,1668.96,1695.67,1812.48,2075.08,1932.88,2214.88,1321.14,1439.98,1490.56,1331.46,1550.86)
squaremeters=c(48,51,53,55,57,58,64,68,68,72,73,73,73,74,75,76,77,77,77,78,79,79,79,79,80,81,82,84,85,85,85,86,92,92,92,93,94,95,95,97,97,98,98,100,103,103,105,105,110,122)
data=data.frame(price, age, distance, squaremeters)
data

#Normality
library(dplyr)
library(nortest)

 
# Solution 1 on normality test
ks.test(data$price, "pnorm", mean(price), sd(price))
ad.test(data$price) # Anderson-Darling normality test

# Solution 2
data%>% summarise(statistic = ks.test(price, "pnorm", mean(price), sd(price))$statistic, p.value = ks.test(price, "pnorm", mean(price), sd(price))$p.value)
data%>% summarise(statistic = ad.test(price)$statistic, p.value = ad.test(price)$p.value)


#normality test on age 
ks.test(data$age, "pnorm", mean(age), sd(age))
ad.test(data$age)
  
#normality test on distance 
ks.test(data$distance, "pnorm", mean(distance), sd(distance))
ad.test(data$distance)

#Normality test on squaremeters
ks.test(data$squaremeters, "pnorm", mean(squaremeters), sd(squaremeters))
ad.test(data$squaremeters)

#Correlation
#Compute the correlation coefficient for all pairwise combinations of the variables
#Constract all the scatter plots
#install.packages("Hmisc")
library(Hmisc)

# Solution 1
rcorr(as.matrix(data))

# Solution 2
data%>% as.matrix %>% rcorr()

# Solution 1
plot(data)

# Solution 2
data%>% plot()

# Solution 3
#install.packages("corrplot")
library(corrplot)
correlations = cor(data)
correlations
corrplot(correlations, method = "circle")


corrplot(correlations, method = "circle", type="upper") # Display only the upper panel

corrplot(correlations, method = "number") # Display the correlation coefficients 
corrplot(correlations, method = "number", type="upper") # Display only the upper panel

# Instead of the plot function, you can use the pairs function
pairs(data, col = "blue")

# Display only the upper panel
pairs(data, col = "blue", lower.panel = NULL)

# For a better visualization tool, we 
# can use the "psych" package and the pairs.panel() function

library(psych)
pairs.panels(data, ellipses=FALSE)



#Simple Linear Regression
# - lm: Fitting Linear Models
fit<-lm(price~age,data = data) # Fit a linear model 
 
summary(fit) # price=410.359-19.971*age

anova(fit) # Ηο: b1=0 vs H1: b1≠0

#Examine the hypothesis that the standardized residuals e are random and follow the Normal distribution

standardized.residuals=rstandard(fit)

Mean.Stand=mean(standardized.residuals)
sd.Stand=sd(standardized.residuals)
ks.test(standardized.residuals, "pnorm", Mean.Stand, sd.Stand)
library(nortest)                           
lillie.test(standardized.residuals)        # small variation of the K-S test
shapiro.test(standardized.residuals)       # Shapiro-Wilk normality test
ad.test(standardized.residuals)            # Anderson-Darling normality test

#Examine the hypothesis that the studentized residuals have constant variance. 

studentized.res = rstudent(fit)
# Alternatively, use function studres of MASS package
library(MASS)
studentized.res = studres(fit) 

##
# For scatterplot  (Χ,e studentized):
#install.packages('MASS')

library(ggplot2)
library(dplyr)
ggplot(data,aes(x = age, y = studentized.res)) + 
  geom_point() +
  ylab("Studentized Residuals")+
  xlab("age")


# For scatterplot (Υ-predicted,e studentized)   
ggplot(data, aes(x = predict(fit) %>% scale, y = studentized.res)) +
  geom_point() +
  ylab("Studentized Residuals") +
  xlab("Standardised Predicted Value")

# For scatterplot (Υ,Υ-predicted)  
ggplot(data, aes(x = price, y = predict(fit) %>% scale)) +
  geom_point() +
  ylab("Standardised Predicted Value") +
  xlab("price")

#Residuals' Independency -  Durbin-Watson Test for Autocorrelated Errors
library(car)
durbinWatsonTest(fit)
# The Durbin-Watson statistic will always have a value ranging between 0 and 4.
# A value of 2.0 indicates there is no autocorrelation detected in the sample.
# Values from 0 to less than 2 point to positive autocorrelation 
# and values from 2 to 4 means negative autocorrelation
# H0 (null hypothesis): There is no correlation among the residuals. rho = 0
# HA (alternative hypothesis): The residuals are autocorrelated. rho != 0

library(lmtest)
dwtest(fit, alternative = "two.sided") # alternative function for Durbin-Watson test


# Multiple linear regression
#that relates the property’s price to the property’s age, its distance from the city center, and its square meters. 
fit1 = lm(price ~ age + distance + squaremeters, data = data)
summary(fit1)
 
anova(fit1) # Compute an analysis of variance table for one or more linear model fits
# The table  contains F statistics (and P values) comparing the mean square for the row to the residual mean square.
# If more than one object is specified, the table has a row for the residual degrees of freedom and sum of squares for each model.

par(mfrow=c(2, 2))
plot(fit1)

library(car)
durbinWatsonTest(fit1)

library(lmtest)

bptest(fit1) #Breusch-Pagan test

dwtest(fit1)

