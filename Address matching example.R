

rm(list=ls())

library(stringdist)
library(data.table)



# made up example addresses
data.1 <- data.table(Address=c("123 Main St.","434 W. Pine Ave.",
                               "12567 Ottawa Pl","2 Broadway St.","4214 Sparrowbrook Cir."),
                     Zipcode=c(80305,42356,56894,94328,80126),
                     Other.data.1=rep("example stuff",5))

data.2 <- data.table(Address=c("123 Main St","123 Maine St",
                               "434 Pine Ave","34 8th Ave",
                               "2134 Broadway St","4214 Sparrowlark Cir"),
                     Zipcode=c(80305,80305,42356,56712,94328,80126),
                     Other.data.2=rep("other example stuff",6))

data.1
data.2                     
                     

# data.1 row 1 should match data.2 row 1
# data.1 row 2 should match data.2 row 3
# the rest should not match


# function to split the street number and street name
# returns a data table with one column for number and one for street name
splitAddress <- function(addr){
  
  #seperate street number and address using the "\t" character
  nonum <- grepl("^[^0-9]", addr)
  addr[nonum] <- paste0(" \t", addr[nonum])
  addr[!nonum] <- gsub("(^[0-9]+ )(.*)", "\\1\t\\2", addr[!nonum])
 
  table <- setnames(data.table(read.delim(text = addr, header = FALSE)),
                      c("street.number","street.name"))
 
  table$street.number <- as.numeric(table$street.number)
  
  # address is all lower case and removes periods and commas
  table$street.name   <- gsub("[.,]", "",tolower(table$street.name))
  
  return(table)
}

table.1 <- splitAddress(data.1$Address)
table.2 <- splitAddress(data.2$Address)

table.1$zip <- data.1$Zipcode
table.2$zip <- data.2$Zipcode

table.1
table.2
  



#function that takes a single row containing street.number,street.name, and zip
# then tries to match it with a table of addresses using max.dist
selectMatch <- function(addr,table,max.dist){
  
  # first element is street number, second is street name, third is zip
  addr <- unlist(addr,use.names = F)
  
  table$row.ID <- as.numeric(row.names(table))
  
  #keep addresses with the same street number and zip as the target address
  number.match <- table[street.number==as.numeric(addr[1]) &
                          zip==as.numeric(addr[3])]
  
  #of the address that match street number and zip, select the address which is most 
  #similar to the target address, if the distance is < = maxDist
  # maxDist can be adjusted as needed to suit needs
  final.match <- number.match[amatch(addr[2],number.match$street.name,
                                     method="osa",maxDist=max.dist)]
  
  return(final.match)
  
}


# gets correct result with this example for max.dist of 2 or 3
# normally max.dist can give correct results much greater than 3 but the sparrowbrook example is tricky
result <- data.table(t(sapply(split(table.1,seq(nrow(table.1))),
                              FUN=selectMatch,table=table.2,max.dist=3)))
result <- setnames(result,c("matched.street.number","matched.street.name","matched.zip","matched.row.ID"))

matches <- cbind(table.1,result)

matches


# function to standardize matches so that they can be merged
# data.standard is the data set which contains the addresses used as "addr" in selectMatches
# data.orginal is the data set which was used as "table" in selectMatches 
standardizeMatches <- function(data.standard,data.original,match.result){
  
  row.ID.2 <- unlist(match.result[!is.na(matched.row.ID)]$matched.row.ID)
  row.ID.1 <- as.numeric(row.names(match.result[row.ID.2]))
  
  data.original$Original.Address <- data.original$Address
  
  data.original[row.ID.2]$Address <- data.standard[row.ID.1]$Address
  
  return(data.original)
  
}

table.new <- standardizeMatches(data.1,data.2,matches)


#merge using the newly standardized addresses
#see all rows
final.full <- merge(data.1,table.new,by="Address",all=T)
#keep only matches
final <- merge(data.1,table.new,by="Address")


final


