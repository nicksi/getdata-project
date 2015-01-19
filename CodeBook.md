# Code Book for activity.txt file

This file contains data collected from the accelerometer and gyroscope 3-axial raw signals These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz.

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals. Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm. Finally a Fast Fourier Transform (FFT) was applied to some of these signals.

Finally all data samples was averaged on subject/type of measurement.

First few rows of data
```
subject activity mode parameter measure axis       value component datasource
1         LAYING time              mean    X  0.22159824      Body        Acc
1         LAYING time              mean    Y -0.04051395      Body        Acc
1         LAYING time              mean    Z -0.11320355      Body        Acc
1         LAYING time              mean    X -0.24888180   Gravity        Acc
1         LAYING time              mean    Y  0.70554977   Gravity        Acc
1         LAYING time              mean    Z  0.44581772   Gravity        Acc
```

There are following variables in data:

- `subject` - ID of the test subject(person)
- `activity` - activity type. Can take following values: 
    LAYING, SITTING, STANDING, WALKING, WALKING_DOWNSTAIRS, WALKING_UPSTAIRS
- `mode` - the type of measurment. **Time** - refers for the time domain signals, while 
**frequency** stands for data after Fast Fourier Transform (FFT) was applied
- `datasource`- define if data was collected from gyroscope (**Gyro**) or acceleremometer (**Acc**)
- `component` - for accelearation signal represents **body** and **gravity** components
- `parameter` - show if measure is raw **NA**, shows jerk (**Jerk**), magnitude (**Mag**) or jerk margnitude (**JerkMag**)
- `axis` - measurment axis: **X**, **Y**, **Z** or NA 
- `measure` - type of the measure aaveraged: mean values (**mean**) or standard deviation (**std**)
- `values` - measurment values

You can use following code to load data:
```
test <- read.table("aggregate.txt", header = TRUE)
```

