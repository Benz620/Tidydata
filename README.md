# Tidydata

1. I start by loading all the necessary packages to begin my work. I mainly use the "data" and "plyr" packages. The "dplyr" function in the "plyr" package will be useful later to create a string vector of a list of paths for each file in the zip document.

2. I read all the files and combine them using effectively "cbind" and "rbind". I label all the columns with the features vector. I use the "join" function to apply all the corresponding activity labels with their appropriate numbers from the "y.text" file.

3. Then I use "select" to choose all the calculations on the mean and standard deviation.

4. Later, I use the "data.table" package by making "data = data.table(data)".

5. I calculate the mean for each variable by subject and activity. I use the "lapply" function to calculate the mean for each column. The "argument.SD" allows me to calculate the mean for all the selected variables
