#Command line example of using the DLMtool
#load library
library(DLMtool)

#Running TAC estimation with DLMobject
#access example data objects
for(i in 1:length(DLMdat))assign(DLMdat[[i]]@Name,DLMdat[[i]])
avail('DLM_data') 
Ex_dlm.data<-new("DLM_data",stock="C:/Users/Jason.Cope/Documents/GitHub/Data-limited-tools/Shiny_DLMtool/DLM_objects_examples/Example_datafile.csv")

#Example:explore dlm object
slotNames(Ex_dlm.data) #checks object inputs
summary(Ex_dlm.data) #Plots summary of removals, abundnace indices and input priors
Can(Ex_dlm.data)   #Methods that can be used
Cant(Ex_dlm.data)  #Methods that cannot be use
Needed(Ex_dlm.data) #What data needed for each "cant" method
#Calculate and plot catch estimates
Ex_dlm.data.TAC<-TAC(Ex_dlm.data)
plot(Ex_dlm.data.TAC)

boxplot(t(Ex_dlm.data.TAC@TAC[,,1]),horizontal=TRUE,ylim=c(0,250),axes=F,xlab="Total Allowable Catches",ylab="")
box()
axis(1)
axis(2,at=c(1:length(Ex_dlm.data.TAC@MPs)),labels= Ex_dlm.data.TAC@MPs,las=2)
#Sensitivity to specified method and its inputs
Example_DCAC_sensi<-Sense(Ex_dlm.data.TAC,"DCAC")

#############################

###### MSE Example ######
#Make newe Operating model
avail('Stock')
ourstock <- Snapper
slotNames(ourstock)
ourstock@M

# Overwrite the pre-specified property values 
ourstock@M <- c(0.2,0.25)
ourstock@maxage <- 18
ourstock@D <- c(0.05,0.3)
ourstock@Frac_area_1 <- c(0.05,0.15)
ourstock@Prob_staying <- c(0.4,0.99)
#Expore or change inputs
slotNames(OM)
OM@Name

# Choose a fleet type and 
# generic fleet of flat recent effort, adding dome-shaped vulnerability as a possibility for older age classes: 
avail("Fleet")
ourfleet <- Generic_FlatE
ourfleet@Vmaxlen <- c(0.5, 1)

avail("Observation")
ourOM <- new('OM',ourstock, ourfleet, Imprecise_Biased)

#Choose which methods to test
MPs <- c("BK", "CC1", "CompSRA", "DBSRA", "DBSRA4010", "DCAC", "DCAC4010", "DepF", "DynF",
         "EDCAC", "Fratio", "Itarget1", "Itarget4", "MCD", "MCD4010", "SBT1")

#Run MSE
ourMSE <- runMSE(ourOM, MPs=MPs, proyears=20, interval=5, nsim=16,reps=1)

#Summarize results
Results <- summary(ourMSE) 

#Plots
plot(ourMSE)
Tplot(ourMSE) # trade-offs plot
Pplot(ourMSE) # overfishing trajectories plot
Kplot(ourMSE) # kobe plots
VOI(ourMSE) #value of information plot
