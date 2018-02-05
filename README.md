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
- A console opens, paste the following code at the very end of it:
```
macro "Measure And Label [j]" {
	fontSize = 12;
	label = getString("Label:", "A");
	run("Measure");
	setResult("Label", nResults-1, label)
	updateResults();
}
```
- Restart FIJI

**Now you can measure with 2 different tools:**
 - [m] let you measure the data as defined in Analyse > Set Measurements...
 - [j] measures just like [m], and asks you for a label for each measurements.

### gettable(getcolumn="Length", scale = 2, columns )
	
It will allow you to have raw [Fiji data](RawFijiTemplate.csv) turned into
[clean tables](ProcessedPhenoData.csv).
The conditions for this script to work properly are:
- You always have the same amount of measurements (same amount of columns)
- You are interested in the values of only one column of the Fiji results 
- You only have raw .csv Fiji results files in the folder in which you run the script
	
Arguments :
- getcolumn = name of the column that has the measurements you want to extract.
- scale = unit of the scale you measured. By default 2 cm if you extract the "Length" column, but would be 2 square cm if it was the "Area" column choosed. If FALSE, it won't make a scale and keep your raw measurements.
- columns = an object containing the name of each of your column. 
