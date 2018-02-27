
REM Usage: Clustering "filename1,filename2" "seeds"
REM Usage: Clustering "ISQA8700\Homework4Data.xls ISQA8700\Homework4Data2.xls" "1,2"

REM This will run the cluster against the first file and retain the seed for the second file
REM To run all data as seeds to locate best score exclude "1,2"

java -jar Clustering.jar "C:\Users\Al\Documents\MBA\ISQA8700\Homework4Data.xls, C:\Users\Al\Documents\MBA\ISQA8700\Homework4Data2.xls" "1,6"

pause