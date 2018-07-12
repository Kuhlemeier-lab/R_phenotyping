# R_for_phenotyping-
You will find here all the R codes (and why not all the codes at all?) that could help in the phenotyping process. For each new file, please add a description in this readme. Use the name of your file to put it in the alphabetical order.

## AmazingFijiFunctions.R
	
This script contains functions (only one for now) that help processing data taken directly from the software Fiji,
taken together with a modified version of the "Measure and Label" macro. With this script, R will use the "Label" column
in the Fiji results table to know how to process the data.
	

In order to can use it, please set Fiji the following way:

- Install [FIJI](https://fiji.sc/)
- Open FIJI
- Open any picture and make a measurement using [m]
- The Results table opens. In it, go to Results > Options...
- In File extension for tables (.csv, .tsv, .txt), write ".csv"
- Click OK
- Close the Results table
- Go to Plugins > Macros > StartUp Macros...
- A console opens, paste [this macro](Label_Fiji_Macro.txt) at the very end of it.
- Don't forget to save your changes and restart FIJI

**Now you can measure with 2 different tools:**
 - [m] measures the data as defined in Analyse > Set Measurements...
 - [j] measures just like [m], store your picture name, its date of last modification and asks you for a label for each measurement.
 
 ### How to take measurements with AmazingFijiFunctions.R ?
 
 Before taking the measurements, think about the scale: Is it the same for all your pictures ? Is it different
 for each picture ? Are there series of pictures with different scales ?
 
 #### Same scale for all my pictures
 Put all your pictures in a folder and start with making the scale. To do so, measure the length that you want using
 the *Straight* tool and press [j] to use the "Measure And Label" macro. Call this measurement **scale**. You can then
 make the measurements you want on the following pictures without worrying about the scale: the ```gettable()``` function
 will do it for you.
 
 #### Series of different scales
 I recommand you to put the different series in different files, that way you won't need to redo the scale every few images.
 Then proceed in each folder like said just above.
 
 #### Different scale for each picture
 Poor you, it'll take you significantly longer! But don't worry, Vivi daddy can help you:
 
 The best solution is to use the *Analyze > Set Scale...* tool. But it'll get annoying if you have to reach it every time.
 To go faster, create a keyboard shortcut! Go to *Plugin > Shortcuts > Add Shortcut...*
 In **Command**, select **Set Scale...**, in **Shortcut**, I recommand you to put **q**. This short hint will allow you to make the scale
 very efficiently as for each picture you'll only need to measure your scale, press **q**, press **Tab**, indicate the scale,
 and press **Enter** to confirm. Three annoying clicks saved for each pictures! After making the scale, you can proceed and 
 take your measurements as described below. When you'll ask ```gettable()``` to process your data, remember to set
 ```scale==FALSE```in the arguments.
 
 #### Collecting data
 At last you can do it! For each of your picture, first take the first measurement of the serie and press [j]. Enter the name of
 the individual you are measuring and take the rest of its measurements with [m]. Remember to name each individual, **even if
 several of them have the same name**. It is extremely important as ```gettable()```will use the names to process
 the data. You can decide at any time to redo the scale. If you have some data missing, take a random measurement with [j]
 and call it **ND**. When it will process your data, ```gettable()``` will replace it with a NA.
 

### gettable function
```
gettable(getcolumn="Length", scale, columns, output = "" )
```

It will allow you to have raw [Fiji data](DataStock/RawFijiTemplate.csv) turned into [clean tables](DataStock/ProcessedPhenoData.csv).
The conditions for this script to work properly are:
- You always have the same amount of measurements (same amount of columns)
- You are interested in the values of only one column of the Fiji results 
- You only have raw .csv Fiji results files in the folder in which you run the script
	
Arguments :
- getcolumn = name of the column that has the measurements you want to extract.
- scale = unit of the scale you measured. There is no default value so you must specify it every time you run the function. If FALSE, it won't make a scale and keep your raw measurements.
- columns = an object containing the name of each of your column. 
- output = default value "" prints the table to STDOUT. If a string is provided, the table is saved in a `<string`>.csv file in the working directory.

## Allgraphs.R

This script contains a function (based on ggplot2) to allow you to make series of boxplots saved in .png 
in a new folder.It's ment to save some time by avoiding to type or correct every new plot code lines.

### allgraphs function
```
allgraphs(dataframe, foldername="AllGraphs", x, y, jitter=TRUE)
```

- dataframe: name of the dataframe to make plots with.
- foldername: name of the new directory that will be created to store pictures. The directory will be created in your working directory.
- x: An integer giving the number of the columns (up to 2) that will be used on the x axis.
- y: An integer giving the number of the columns that will be used on the y axis. There will be one graph per column.
jitter: either TRUE or FALSE, shows each data point on the boxplots.

#### Examples
In R, with the working directory set in [DataStock](DataStock). allgraph will be run on [this data]( DataStock/allgraph_data_example.csv ).
```
> allgraphs(allgraph_data_example, foldername = "allgraph_output",x=c(1,2),y=c(3,9:15),jitter=TRUE)
```
[This directory](DataStock/allgraph_output) has been created and the graphs have been saved.
