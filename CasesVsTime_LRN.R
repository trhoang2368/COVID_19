setwd("../Documents/Spring 2020/Honor Math/COVID 19")
covid.data <-read.csv ("./USA_Deaths_and_Confirmed_Cases.csv",header=TRUE)
new.covid <- subset(covid.data, Time >=3.5 ,
                    select=Total.Deaths:Time) 
dths = new.covid$Total.Deaths
cases= new.covid$Total.Cases
time = new.covid$Time

#Up until April 30
real.cases <- c(31667,30833,32922,24601,28065,37289,17588,26543,21352,48529,26857,22541,24132,27326)
real.cases[1] <- max(cases)+real.cases[1]
real.dths <- c(2299,3770,1856,1772,1857,2524,1721,3179,1054,2172,1687,1369,2110,2611)
real.dths[1] <- max(dths)+real.dths[1]

for ( i in 2:length(real.cases)){
  real.cases[i] <- real.cases[i-1]+real.cases[i]
  real.dths[i] <- real.dths[i-1]+real.dths[i]
}
cases <- append(cases, real.cases)
dths <- append(dths, real.dths)
for (i in 17:30){ time <- append(time, 4+(i-1)/30)}


#Function to help in the analysis process
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

#Original test for autocorrelation: 
mod.ori <- lm(cases~time)
dwtest(mod.ori)
#DW for original = 0.051293 << => autocorrelation is larger than 0 

#Transform 1
rho_test= rho.test(time,cases,0.0, 1.0, 0.01)
cases.prime = trans.var(cases,rho_test)
time.prime = trans.var(time,rho_test)
mod1 <- lm(cases.prime~time.prime)
summary(mod1)
dwtest(mod1)
#For n=44, dU=1.57; D= 1.7216 => Conclude rho =0 

#Refitted the model: 
b1 = mod1$coefficients[2]
b0 = mod1$coefficients[1]/(1-rho_test)
plot(time,cases,main="Fitted Plot after Autocorrelation",ylab="Total Cases",xlim=c(3.5,5.0),ylim=c(60,max(cases)+400000),pch=19)
curve(b0+b1*x, col="red",add=TRUE)
res.mod <- cases -(b0+b1*time)


#Forecasting confirmed cases in the USA from May 1st uptil May 15th 
# In May 1st and May 15th 
time_new <- c()
for (i in 1:15){ time_new <- append(time_new, 5+(i-1)/30)}
e_n <- res.mod[length(res.mod)]
mse.mod1 <- sum(mod1$residuals**2)/mod1$df.residual
f_new <- c() 
s.pred <- c()
pred.interval <- c()
#dummie <-c()
for (i in 1:length(time_new)){
  f_new <- append(f_new, b0+b1*time_new[i]+rho_test^(i)*e_n)
  dummie <- mse.mod1*(1+1/length(time)+(time_new[i]-mean(time))^2/sum((time-mean(time))**2))
  s.pred <- append(s.pred, sqrt(dummie) )
  pred.interval <- append(pred.interval, sqrt(dummie)*qt(.975,length(cases)-3) )# Predicting the rho makes us loss a degree of freedom 
} 
cases1.pred_a <- f_new - pred.interval
cases1.pred_b <- f_new + pred.interval

mult_seg <- data.frame(x0 = time_new,    # Create data frame with line-values
                       y0 =cases1.pred_a,
                       x1 = time_new,
                       y1 = cases1.pred_b)
plot(time,cases,main="Zoom-In Time Series and Fitted Plot",xlim=c(3.0,max(time_new)+0.5),ylim=c(600000,max(cases)+500000),ylab="Total cases",pch=19)
plot(time,cases,main="Time Series and Fitted Plot",ylab="Total Cases", xlim=c(3.5,5.5),ylim=c(60,max(cases)+400000),pch=19)
curve(b0+b1*x, col="red",add=TRUE)
segments(x0 = mult_seg$x0,                            # Draw multiple lines
         y0 = mult_seg$y0,
         x1 = mult_seg$x1,
         y1 = mult_seg$y1)

#Actual data: of May 1st - may 13th
actual <- c(max(cases)+29917,max(cases)+33955+29917, max(cases)+33955+29917+29288)


actual.cases <- c(29917,33955,29288,24972,22593,23841,24128,
                  28369,26957,25612,20258,18117,22048,20782)
actual.cases[1] <- max(cases)+actual.cases[1]

for ( i in 2:length(actual.cases)){
  actual.cases[i] <- actual.cases[i-1]+actual.cases[i]
}
time_actual <- c()
for (i in 1:7){ time_actual <- append(time_actual, 5+(i-1)/30)}
plot(time,cases,main="Zoom-In Time Series and Fitted Plot",xlim=c(3.0,max(time_new)+0.5),
      ylim=c(600000,max(cases)+500000),ylab="Total cases",pch=19)
curve(b0+b1*x, col="red",add=TRUE)
segments(x0 = mult_seg$x0,                            # Draw multiple lines
         y0 = mult_seg$y0,
         x1 = mult_seg$x1,
         y1 = mult_seg$y1)
points(x=time_actual,y=actual.cases,type="p")
legend("bottomright",legend=c("Data","Actual Value"), pch = c(1,19), title="Point")
legend("topleft",legend="Predicted I", lty=1 )

#Calculate Percentage Precision 
actual.may6.14 <- actual.cases[6:14]
pred.may6.14 <- cases1.pred_a[6:14]
forecast.prec <- abs(actual.may6.14-pred.may6.14)*100/actual.may6.14
