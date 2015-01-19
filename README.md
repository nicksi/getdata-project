# getdata-project
Project for the Getting and Cleaning Data course

`run_analysis.R` script can be used to merge and process initial data. Script expects that raw data was unzipped into `data` folder. Script expects that following libraries available: `plyr`, `dplyr`, `tidyr`

The processing results will be stored to the `aggregate.tst` file in the working directory. You can load file using following command: `read.table("aggregate.txt", header = TRUE)`

I choose to use tall form of tidy data, so researcher can later choose how to shape data - by types of measurements (standard deviation or mean), type of processing (time or frequency), etc.

The script implements following data processing approach:
+ First it loads data from test or train sets (`X_test.txt` or `X_train.txt`) and merge them with subjects (`subject_test.txt` or `subject_train.txt`) and activity (`y_text.txt` or `y_train.txt`). Column names are generated from featrues.txt using make.name function

+ Test and training data was merged into one superset and converted into data.table. The subset created and used in all further data manipulations for the faster processing. 

+ After merging data is cleaned from errors and activity codes remapped from numeric ids into strings using data from `activity_labels.txt`

+ I choose to create tall data table my breaking raw variable name into several components and putting each component as separate observation. Such structure will make it easier to choose specific axis, only gyro measurements, etc.

+ Each variable name separated into: measurement mode (time vs. frequency), information source (gyro vs. accelerometer), measurement components (Base vs. Gravity) and extra data (is it direct measurement, jerks or magnitude). I choose not to separate Jerk and Magnitude as separate variables because Magnitude of Jerk movement which is not equal to both Jerk AND Magnitude filters applied to the same measurement


