#  USA Data analysis 
###Linear Regression Model 

setwd("../Documents/Spring 2020/Honor Math/COVID 19")
covid.data <-read.csv ("./USA_Deaths_and_Confirmed_Cases.csv",header=TRUE)

# data frame so it would match our covid data timeframe 
new.elect <- subset(electricity, Time >=min(time) & Time <= max(time) ,
                  select=Chosen.Week.megawatthours:Time) 
rownames(new.elect) <- 1:nrow(new.elect)





#Linear Regression Model on cases + time
cases.time.lm <- lm(cases~time)
summary(cases.time.lm)
#Anlysis of Time vs Cases
plot(cases.time.lm$residuals,time,main='Residual Plot')
plot(time,cases, main='Time vs Confirmed Cases in the US', pch=19)
abline(cases.time.lm,col="red")
legend("bottomright",legend="Fitted Line",col="red",lty=1 ,title="Line Types")
qqnorm(resid(cases.time.lm), ylab = "Residuals")
qqline(resid(cases.time.lm))
hist(cases.time.lm$residuals)



#Non-linear model on cases + time:  Exponential Model
mse.func1 <- function(x,y, gamma){
  a <- sum((y - (gamma[1]+gamma[2]*exp(gamma[3]*x)))**2)
  MSE <- a/(length(y)-length(gamma))
  return(MSE) }

dths = covid.data$Total.Deaths
cases= covid.data$Total.Cases
time = covid.data$Time

plot(time, cases, main="NLR Time vs Cases_Exponetial Model", pch=19,xlim=c(3.0,6.0), ylim = c(0, max(cases)+1000000))
curve(66.0+exp(-1.8)/1.1*exp(3.5*x),add=TRUE, type= "l",lty=1,col="blue")
g_initial <- c(66,exp(-1.8)/1.1,3.5)
mse.data <- mse.func1(time,cases,g_initial)
nlmod1 = nls(cases~a+b*exp(c*time),start= list(a=g_intial[1], b= g_initial[2], c=g_initial[3]))
summary(nlmod1)

g.cases.time <- c(-5.732e+04,3.094e+01,2.247)
mse.cases.time <- mse.func1(time,cases, g.cases.time)
curve(-5.732e+04+3.094e+01*exp(2.247*x),col="red", add=TRUE)
legend("bottomright",legend=c("Guessed Line","Fitted Line"),col=c("blue","red"),lty=1 ,title="Line Types")
res.nlmod1 <- cases - (-5.732e+04+3.094e+01*exp(2.247*time))
plot(time,res.nlmod1,main="Residuals Plot for Exponential model",ylab="Residuals")
qqnorm(res.nlmod1, ylab="residuals")
qqline(res.nlmod1)

#Nonlinear: Logistic Model 
mse.func2 <- function(x,y, gamma){
  a <- sum((y - (gamma[1]/(1+gamma[2]*exp(gamma[3]*x))))**2)
  MSE <- a/(length(y)-length(gamma))
  return(MSE)}

plot(time, cases, main="NLR Time vs Cases_Logistic Model", pch=19,xlim=c(3.0,6.0), ylim = c(0, max(cases)+600000))
curve(750000/(1+10**10*exp(-5.5*x)),add=TRUE, type= "l",lty=1,col="blue")
g_initial2 <- c(750000,10**10,-5.5)
mse.data2 <- mse.func2(time,cases, g_initial2)

nlmod2 = nls(cases~a/(1+b*exp(c*time)),start= list(a=750000, b= 10**10, c=-5.5))
summary(nlmod2)
plot(x,y, xlab="day - X", ylab ="hosp - Y", main="Scatterplot with Fitted Line", pch=19)
gamma.nlmod2 <- c(7.321e+05,2.692e+10,-5.727e+00)
mse.nlmod2 <- mse.func2(time,cases,gamma.nlmod2)
curve(gamma.nlmod2[1]/(1+gamma.nlmod2[2]*exp(gamma.nlmod2[3]*x)),col="red",type="l", lty=1,add= TRUE)
legend("bottomright",legend="Fitted Line",col="red"),lty=1 ,title="Line Types")

res.nlmod2 <- cases -(gamma.nlmod2[1]/(1+gamma.nlmod2[2]*exp(gamma.nlmod2[3]*time))) 
plot(time,res.nlmod2, main="Residual Plots _ Logistic Model", ylab="Residual")
qqnorm(res.nlmod2, ylab="Residuals")
qqline(res.nlmod2)



#Linear Regression Model but with Autocorrelation: 
#Check if the original model is autocorrelated 
dths = covid.data$Total.Deaths
cases= covid.data$Total.Cases
time = covid.data$Time
installed.packages("lmtest")
library(lmtest)
dwtest(lm(cases~time))



