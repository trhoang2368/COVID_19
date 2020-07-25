# Predicting COVID-19 Confirmed Cases in USA 
## File's Description: 
- covid19.R: Create non-linear regression model and linear regression model for both death and confirmed cases. 
- CasesVsTime_LRN.R: Time Series analysis on the confirmed cases using autocorrelation
- Spring-Fest-Poster_Trang.pdf: My poster at Clark University's academic presentation day 
- senior Presentation_pdf.pdf: My presentation for Honors Thesis

## I. Analysis Goal: 
For this project, I want to learn the powerful forecasting and time series analysis in a short period using the concepts of autocorrelation. I pick COVID 19 data to build a forecasting model using R and Python. The result of my analysis 100% precision 5 days in the future and 95% precision 14 days in the future. 

## II. The problem relating to the COVID 19 dataset 
I am focusing on analysing the Confirmed Cases vs Time. Typically, one can just simply use the a normal nonlinear regression model (NLRM) or linear regression model (LRM) to predict the future. However, there exists a correlated error terms in the model, in which the error terms value depends on its past self 

![image](https://user-images.githubusercontent.com/60806068/88416221-d6807300-cdad-11ea-8400-44cea8604ab9.png)


The correlated error terms coming from missing key variables that have ordered effects on the model. In our cases, maybe the Covid 19 model is missing some time-affect variables such as the trasmission rate, on average, how many people do one individual interact daily.
==> Considering autocorrelation in our analysis increases accuracy and precision in our analysis 

## III. Results:

![image](https://user-images.githubusercontent.com/60806068/88429478-bad49700-cdc4-11ea-9d65-12c41dfe763c.png)

Taking a closer look at the forecasting result: 
![image](https://user-images.githubusercontent.com/60806068/88429429-a1cbe600-cdc4-11ea-855d-1b39bf660a14.png)
- The line indicates the forecasting values
- The black dots are the data that used to train the model 
- The while dots are real-time confirmed cases (from May 1st - May 14th)


**Conclusions:** 
- Within the first 5 days (May 1st - May 5th), the predicted values are precisely near the real-time values. 
- Afterward, the precision reduces to 95% precision when forecasting values in the next 9 days (May 6th - May 14th) 
<p> The following table would show you how the precision reduces from 100% to 95% throughout the span of 14 days: </p>
   
![image](https://user-images.githubusercontent.com/60806068/88429557-db9cec80-cdc4-11ea-9a42-c1c31b60844a.png)

## III. Analysis Steps: 
I use both Python - Jupyter and R for my analysis. I use Python for the preprocessing and R for the forecasting and correcting autocorrelation. For the forecasting, I want to determine the precision and the accuracy of my forecasting model (Time Vs Confirmed Cases)

I choose to analyse only time and confirmed case My analysis step:

1) Data Exploratory with Python: .
   - Exploring the casses in the top COVID countries: USA, Spain, Italy 
   - Filtering cases in the USA
   - Calculating the total confirmed cases by day
   - Creating a csv file that report the date with the correspond total confirmed cases
2) Build a NonLinear Regression Model: Exponential model
3) Error analysis (to check for autocorrelation)
- Graphing errors against time and against itself. If there is autocorrelation in the error, the 
4) Apply Remedial for autocorrelation
- Check if the model have autocorrelation using hypothesis testing (Durbin Watson Test) 
- If it doesn't have any autocorrelation, then applying forecasting
5) Forecasting and time series


After forecasting, I want to automate my process;
This is the page in which I am trying to automate my analysis. (web scrabbing then automatically update the R file) 
