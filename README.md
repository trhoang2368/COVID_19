# COVID_19
# I. What is the goal?  
For this project, I want to learn the powerful forecasting and time series analysis in a short period through autocorrelation. I pick COVID 19 data just to experiment with the autocorrelation concepts and not to build an accurate forecasting model.

# II. The problem relating to the COVID 19 dataset 
I am focusing on analysing the Confirmed Cases vs Time. Typically, one can just simply use the a normal nonlinear regression model (NLRM) or linear regression model (LRM). However, there exists a correlated error terms in the model, in which the error terms value depends on its past self 

The correlated error terms coming from missing key variables that have ordered effects on the model. In our cases, maybe our Covid 19 model is missing some time-affect variables such as the trasmission rate, on average, how many people do one individual interact daily.
# III. Analysis
I use both Python - Jupyter and R for my analysis. I use Python for the preprocessing and R for the forecasting and correcting autocorrelation. For the forecasting, I want to determine the precision and the accuracy of my forecasting model (Time Vs Confirmed Cases)


## R Code:
I choose to analyse only time and confirmed case My analysis step:

1. Build a NonLinear Regression Model
   I choose Exponential model
2. Error analysis (to check for autocorrelation)
3. Apply Remedial for autocorrelation
4. Forecasting and time series


After forecasting, I want to automate my process;
This is the page in which I am trying to automate my analysis. (web scrabbing then automatically update the R file) 
