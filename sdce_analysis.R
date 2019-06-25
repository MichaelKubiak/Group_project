temp = list.files(pattern="*.csv")
myfiles = lapply(temp, read.delim)
