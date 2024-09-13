<h1>Statistical analysis of rockets, given a dataset</h1>

<h3>Imputation</h3>
I used the <a href="https://cran.r-project.org/web/packages/mice/index.html">mice</a> package. <br>
It is a package in R that is designed for dealing with missing data through multiple imputation. <br>
It works by creating several complete datasets where the missing values are filled in based on the observed data. <br>
Missing values are filled in with estimated values based on the observed data, <br>
but multiple datasets are created with different estimates to reflect the uncertainty about the missing values. <br>
Each dataset is analyzed separately using standard statistical methods. <br>
The results from these analyses are combined to provide a single, <br>
overall result that accounts for the variability between the different imputed datasets. <br>
