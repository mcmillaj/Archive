## Example script to show how loadSafely function works 

rm(list=ls())

# function that works like load, but won't overwrite variables if the same name
# is already defined
loadSafely <- function(path,new.name="safe",warnings=T){
  
  env1 <- new.env() # create new empty enviroment
  load(path,envir = env1) # load saved R object into new enviroment
  object.name <- ls(env1)[1] # should only be one variable in saved object
  parent <- parent.frame() # the enviroment function was called in
  
  #if warnings is true and user tried to load multiple objects, give a warning
  if(length(ls(env1)) > 1 & warnings==T){
    warning("Data object contains multiple variables. Only 1 will be loaded.",call. = F)
  }
  
  # if object name not already defined in workspace, load object with its original name
  if(!exists(object.name)){  
    
    parent[[object.name]] <- env1[[object.name]] 
    
  # if new object is identical to previous one with the same name, 
  # then overwriting is ok
  }else if(identical(parent[[object.name]],env1[[object.name]])){
    
    parent[[object.name]] <- env1[[object.name]]
    
  # if object name already exists, do not overwrite, 
  #save as name defined by new.name parameter  
  }else{
    
    parent[[new.name]] <- env1[[object.name]]
    
    # inform user that overwrite was prevented
    if(warnings==T){
      warning(paste0("Prevented overwrite of '",object.name,"'. New object named '",
                     new.name,"' instead."),call. = F)
    }
  }
}


rwd <- getwd()

x <- "one thing"

save(x,file=file.path(rwd,"example.Rdata")) # save a variable

rm(x) # remove variable


# Case 1: New object loaded does not have same name as already defined variable
loadSafely(path = file.path(rwd,"example.Rdata"))    
   

# Case 2: New object loaded does have same name as already defined variable,
# but they are identical
x <- "one thing"
loadSafely(path = file.path(rwd,"example.Rdata"))    


# Case 3: New object loaded does have same name as already defined variable,
# and function prevents it from being overwritten, saving the new object as something else
x <- "another thing"
loadSafely(path = file.path(rwd,"example.Rdata"))    





