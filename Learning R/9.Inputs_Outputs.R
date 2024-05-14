###
setwd("./scratch")
getwd()
list.files()

###
system("curl https://raw.githubusercontent.com/Jcbnunez/uvm-fqr/main/Learning%20R/mydata.txt > mydata.txt")
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

write.table(x, 
            file = "", 
            append = FALSE, 
            quote = TRUE, 
            sep = " ",
            eol = "\n", 
            na = "NA", 
            dec = ".", 
            row.names = TRUE,
            col.names = TRUE, 
            qmethod = c("escape", "double"),
            fileEncoding = "")

