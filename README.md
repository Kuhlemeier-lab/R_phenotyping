# R_for_phenotyping-
All the R codes that help phenotyping welcome

A good description coming description soon ^^

Install FIJI (ImageJ 2)

Open FIJI
Open any picture and make a measurement using [m]
The Results table opens. In it, go to Results > Options...
In File extension for tables (.csv, .tsv, .txt), write ".csv"
Click OK
Close the Results table
Go to Plugins > Macros > StartUp Macros...
A console opens, paste the following code at the very end of it paste the following code:

macro "Measure And Label [j]" {
       fontSize = 12;
       label = getString("Label:", "A");
       run("Measure");
       setResult("Label", nResults-1, label)
       updateResults();
  }

Restart FIJI
Now you can measure with 2 different tools:
 - [m] let you measure the data as defined in Analyse > Set Measurements...
 - [j] measures just like [m], and asks you for a label for each measurements.
