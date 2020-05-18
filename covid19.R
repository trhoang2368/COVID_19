#  USA Data analysis 
###Linear Regression Model 

setwd("../Documents/Spring 2020/Honor Math/COVID 19")
covid.data <-read.csv ("./USA_Deaths_and_Confirmed_Cases.csv",header=TRUE)
electricity <- read.csv("./USA_electricity_consumption.csv")
new.covid <- subset(covid.data, Time >=3 ,
                    select=Total.Deaths:Time) 
dths = new.covid$Total.Deaths
cases= new.covid$Total.Cases
time = new.covid$Time

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

#Choose the NonLinear Regression_ Logistic Model choose alpha = 0.1 
#Day 17, April, 2020    #X_h = 4 + (17-1)/30
s.pred <- function(variable,variable_h, mse){
  n<-length(variable)
  s.pred <- c()
  for (i in 1:length(variable_h)) {
    dummie <- mse*(1+1/length(variable)+(variable_h[i]-mean(variable))**2/sum((variable - mean(variable))**2))
    s.pred <- append(s.pred, sqrt(dummie)*qt(0.95, n-2 ))
  }
  return(s.pred)
}

time_new <- c()
for (i in 17:30){ time_new <- append(time_new, 4+(i-1)/30)}
time_new.pred <- c()
time_new.pred <- s.pred(time,time_new,mse.nlmod2)



cases1.pred_a <- c()
cases1.pred_b <- c()
for (i in 1:length(time_new.pred)){
  b <- gamma.nlmod2[1]/(1+gamma.nlmod2[2]*exp(gamma.nlmod2[3]*(time_new[i])))
  cases1.pred_a <- append(cases1.pred_a, b - time_new.pred[i])
  cases1.pred_b <- append( cases1.pred_b, b + time_new.pred[i])
}
mult_seg <- data.frame(x0 = time_new,    # Create data frame with line-values
                       y0 =cases1.pred_a,
                       x1 = time_new,
                       y1 = cases1.pred_b)
plot(time,cases,xlim=c(3.0,max(time_new)+0.5),ylim=c(200000,800000))
segments(x0 = mult_seg$x0,                            # Draw multiple lines
         y0 = mult_seg$y0,
         x1 = mult_seg$x1,
         y1 = mult_seg$y1)
real.cases <- c(31667,30833,32922,24601,28065,37289,17588,26543,21352,48529,26857,22541,24132,27326)
real.cases[1] <- max(cases+real.cases[1])
for ( i in 2:length(real.cases)){
  real.cases[i] <- real.cases[i-1]+real.cases[i]
}
plot(time,cases)





#Linear Regression Model but with Autocorrelation: 
#Check if the original model is autocorrelated 
dths = covid.data$Total.Deaths
cases= covid.data$Total.Cases
time = covid.data$Time
installed.packages("lmtest")
library(lmtest)
dwtest(lm(cases~time))

#Functions: transformed variable   + calculate suitable rho 
trans.var <- function(variable , rho ){
  trans.var <- variable[-1]-rho*variable[-(length(variable))]
  return(trans.var)
}
rho.test<- function(x,y,a,b,c){
  rho_dum <- c(seq(from = a, to = b, by = c))
  SSE_dum <- c()
  for (i in 1:length(rho_dum)){
    y_t <- trans.var(y,rho_dum[i])
    x_t <- trans.var(x, rho_dum[i])
    model_dum <- lm(y_t~x_t)
    m= sum( (y_t-model_dum$coefficients[1]-model_dum$coefficients[2]*x_t)**2)
    SSE_dum <- append(SSE_dum, m )
  }
  SSE1 <- min(SSE_dum)
  loc <- which.min(SSE_dum)
  rho1 <- rho_dum[loc]
  return(rho1)
}


rho_test= rho.test(time,cases,0.0, 1.0, 0.01)
cases.prime = trans.var(cases,rho_test)
time.prime = trans.var(time,rho_test)
mod1 <- lm(cases.prime~time.prime)
summary(mod1)
dwtest(mod1)
residual.data <- cases-(mean(cases)-mod1$coefficients[2]*mean(time)+mod1$coefficients[2]*time)


DW_mod1<- 0
for (i in 2:(length(mod1$residuals))){
  DW_mod1 <- DW_mod1 + (mod1$residuals[i]-mod1$residuals[i-1])**2
}  #e_t_1 for model1
DW_mod1 <- DW_mod1/sum(mod1$residuals^2)



rho_test2 = rho.test(time.prime, cases.prime,0.0, 1.0, 0.01 )
cases.prime2 = trans.var(cases.prime,rho_test)
time.prime2 = trans.var(time.prime,rho_test)
mod2 <- lm(cases.prime2~time.prime2)
summary(mod2)

# Getting the first term because it is an outlier
plot(time.prime[-1],resid(mod1)[-1],main="residual plot of T vs Cases after autorcorelation")
hist(resid1)[-1]

#Check for constant variable: (doesnt have to do with the model_ this one is only for testing)
x1 <- time[1:22]
x1.res <- res.mod[1:22]
x2<- time[23:45]
x2.res <- res.mod[23:45]
d1 <- abs(median(x1)-x1.res)
d2 <- abs(median(x2)-x2.res)
mse.mod <- sum(res.mod**2)/(length(res.mod)-2)
t_value <- (mean(d1)-mean(d2))/sqrt(mse.mod*(1/23+1/22))
