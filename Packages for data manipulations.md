This document presents some tools in the packages dplyr, tidyr and readr that help to clean and manipulate data in R.
It is based on the lesson "Getting and Cleaning data" from the swirl package.

# Package dplyr

Base function to make a special table, whose print is more informative than a simple data frame print.
tbl_df(object)

## 5 principle verbs functions:
### select(mydf, colname1, colname2, colname3)
- can subset only columns
- prints 3 columns from the mydf data frame. The columns are shown in the order specified.
- Possible to use the ":" to print a serie of columns just like making a serie of numbers.
- can use the "-" to remove one column
- can combinethe 2 last points to remove a serie of columns : -(column2:column5)

### filter(mydf, colname=="value")
- can subset rows
- can specify as many conditions as I want, separated by commas.
- can use any logical or boolean operators that I want
- | is the operator OR, & is AND
- can use is.na() type functions as well as !is.na()

### arrange(mydf,colname)
- sort in function of a variable, ascending value by default.
- can replace colname with desc(colname) if you want to arrange by descending value
- can use several colnames separated by a coma, it will sort prioritising the first one, then the second, etc.

### mutate(mydf, newcol1=colname*12, newcol2=newcol1+42)
- create a new column in the data frame named newcol, based on another column.
- can create several new columns in only one line of code.

### summarize(mydf,mean(colname))
summarize(mydf,newobject=mean(colname))
- applies the function to the column that you want.
- can create a new object with the  second line writing.
- can put several arguments that will be returned one after the other.
- interesting only if used together with group_by function.

## More functions:

### group_by(mydf, colname)
- doesn't change the data, but inserts in it a "by group" dynamic when using another function.
	- i.e. summarize(mydf,mean(colname)) will return a data frame containing the mean of each group in colname

### %>%
- opérateur dlyr. Tout ce qui est à gauche devient le premier argument des functions à droite. Facilite l'écriture.


# Package tidyr

### gather(data,...)
Allows to gather columns in a data that's not clean.
Example:

\>students

|  |grade |male |female
  |---|---|---|---
1     |A    |1      |5
2     |B    |5      |0
3     |C    |5      |2
4     |D    |5      |5
5     |E    |7      |4

This table contains in fact 3 variables : grade, sex and count. We then have 2 columns that are not variables.

\>gather(students, sex, count, -grade)

|   |grade    |sex |count
|---|---|---|---
1      |A   |male     |1
2      |B   |male     |5
3      |C   |male     |5
4      |D   |male     |5
5      |E   |male     |7
6      |A |female     |5
7      |B |female     |0
8      |C |female     |2
9      |D |female     |5
10     |E |female     |4

Which is clean, with one variable per column.


### separate(data, col, into, sep)

Splits a column into more columns based on the separator.
Example:

\> res

|   |grade |sex_class |count
|---|---|---|---
1      |A    |male_1     |3
2      |B    |male_1     |6
3      |C    |male_1     |7
4      |D    |male_1     |4
5      |E    |male_1     |1
6      |A  |female_1     |4
7      |B  |female_1     |4
8      |C  |female_1     |4
9      |D  |female_1     |0
10     |E  |female_1     |1
11     |A    |male_2     |3
12     |B    |male_2     |3
13     |C    |male_2     |3
14     |D    |male_2     |8
15     |E    |male_2     |2
16     |A  |female_2     |4
17     |B  |female_2     |5
18     |C  |female_2     |8
19     |D  |female_2     |1
20     |E  |female_2     |7

\> separate(res,sex_class,c("sex","class"))

|   |grade    |sex |class |count
|---|---|---|---|---
1      |A   |male     |1     |3
2      |B   |male     |1     |6
3      |C   |male     |1     |7
4      |D   |male     |1     |4
5      |E   |male     |1     |1
6      |A |female     |1     |4
7      |B |female     |1     |4
8      |C |female     |1     |4
9      |D |female     |1     |0
10     |E |female     |1     |1
11     |A   |male     |2     |3
12     |B   |male     |2     |3
13     |C   |male     |2     |3
14     |D   |male     |2     |8
15     |E   |male     |2     |2
16     |A |female     |2     |4
17     |B |female     |2     |5
18     |C |female     |2     |8
19     |D |female     |2     |1
20     |E |female     |2     |7

In this example, we didn't call a separator. In this case, the function is programmed to know that we mostly separate with non-alphanumeric characters.


### spread(data, key, value,...)

spread one column into several, filling it with the values of another.
data= data frame
key= name of the column to spread
value= values filling the new columns

\>students3

|   | name |   test | class |grade|
|---|---|:---:|---|---| 
|1|  Sally| midterm |class1  |   A|
|2|  Sally|   final |class1  |   C|
|9|  Brian| midterm |class1  |   B|
|10| Brian|   final |class1  |   B|
|13|  Jeff| midterm |class2  |   D|
|14|  Jeff|   final |class2  |   E|
|15| Roger| midterm |class2  |   C|
|16| Roger|   final |class2  |   A|
|21| Sally| midterm |class3  |   B|
|22| Sally|   final |class3  |   C|
|27| Karen| midterm |class3  |   C|
|28| Karen|   final |class3  |   C|
|33|  Jeff| midterm |class4  |   A|
|34|  Jeff|   final |class4  |   C|
|37| Karen| midterm |class4  |   A|
|38| Karen|   final |class4  |   A|
|45| Roger| midterm |class5  |   B|
|46| Roger|   final |class5  |   A|
|49| Brian| midterm |class5  |   A|
|50| Brian|   final |class5  |   C|

\>spread(students3, test, grade)

|    |name  |class |final |midterm
|---|---|---|---|---
1  |Brian |class1     |B       |B
2  |Brian |class5     |C       |A
3   |Jeff |class2     |E       |D
4   |Jeff |class4     |C       |A
5  |Karen |class3     |C       |C
6  |Karen |class4     |A       |A
7  |Roger |class2     |A       |C
8  |Roger |class5     |A       |B
9  |Sally |class1     |C       |A
10 |Sally |class3     |C       |B


# Package readr

### parse_number(...)
Takes only the number from the argument.
Also exist as parse_character(), and others.

