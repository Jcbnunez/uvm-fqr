###
setwd("scratch")
getwd()

list.files()

###
system("curl https://raw.githubusercontent.com/Jcbnunez/uvm-fqr/main/Learning_R/mydata.txt > mydata.txt")

list.files()

###
mydata = read.table("mydata.txt")
mydata

mydata = read.table("mydata.txt", header = TRUE)
mydata
?read.table


### ---> saving data 
### Two formats

### binary
save(mydata, file = "mydata.Rdata")

list.files()
load("mydata.Rdata")

### text
?write.table()

write.table(mydata, 
            file = "mysavedfile.txt", 
            append = FALSE, 
            quote = FALSE, 
            sep = "\t",
            eol = "\n", 
            na = "NA", 
            dec = ".", 
            row.names = FALSE,
            col.names = TRUE, 
            qmethod = c("escape", "double"),
            fileEncoding = "")

list.files()