<h1>Statistical analysis of missiles, given a dataset</h1>

<h3>Introduction</h3>
We are working with a dataset of ballistic missiles and their respective names, NATO reporting names, mass in kilograms,
length in meters, caliber in meters, number of subheads, payload in kilograms, type (not in detail, just aggregate state) of fuel,
maximal range in kilometers, launch mode, number of engine stages and their class by range. <br>

<h3>Imputation</h3>
I used the <a href="https://cran.r-project.org/web/packages/mice/index.html">mice</a> package. <br>
It is a package in R that is designed for dealing with missing data through multiple imputation. <br>
It works by creating several complete datasets where the missing values are filled in based on the observed data. <br>
Missing values are filled in with estimated values based on the observed data, <br>
but multiple datasets are created with different estimates to reflect the uncertainty about the missing values. <br>
Each dataset is analyzed separately using standard statistical methods. <br>
The results from these analyses are combined to provide a single, <br>
overall result that accounts for the variability between the different imputed datasets. <br>


<h3>Splitting the data and training first models</h3>
After splitting the data in 80/20 ratio for training and testing respectively, we train the naive linear regression model.
We use Mean Absolute Error as that seems better for this data.
Let's see if we can get MAE down from ~890 using better model.

<h3>Better models</h3>

<h4>Principal Component Analysis</h4>
Principal component analysis (PCA) is a linear dimensionality reduction technique.
As there are three maximal range categories: S, M and L, by identifying them as groups we can better predict <br>
specific maximal range of a missile, after putting Linear Regression model on such data.

<h3>Classifier of the launcher mobility</h3>
Now, we are trying to make a classifier that predicts if the launcher of the missile is mobile or isn't.
"Silos" entry is the only fixed missile launcher type in the data, RM TEL being mobile vehicle specialized in carrying and launching missiles.


Literature: <br>
https://www.brahmos.com/content.php?id=10&sid=9 <br>
https://medium.com/@byanalytixlabs/what-are-lasso-and-ridge-techniques-05c7f6630f6b <br>
https://www.geeksforgeeks.org/cross-validation-in-r-programming/ <br>
https://www.statology.org/lasso-regression-in-r/ <br> 
https://www.datacamp.com/tutorial/pca-analysis-r <br>
