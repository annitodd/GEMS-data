# global variables and functions used
# Ling Jin 
# last updated 5/19/2023

stage1.factor <- function(data_scaled, nfactor,cutoff = 0.3){
  # factor analysis in stage 1
  
  factor <- fa(data_scaled, nfactors = nfactor, # number of factors
                 rotate = "oblimin", # how (if at all) to rotate the factors
                 fm="minres", # what factor extraction method to use. here maximum likelihood
                 max.iter = 10000, missing = TRUE, impute = "median", warnings = TRUE)
#  print(factor)
 print(factor$loadings,cutoff = cutoff) # show factor loadings and variation explained
  
#  loadings <- factor$loadings
  # psych::fa2latex(factor, digits=3,rowlabels=TRUE,apa=TRUE,short.names=FALSE,cumvar=T, cut=cutoff,big=.3,alpha=.05,font.size ="scriptsize",
  #          caption= paste('TransGeo',nfactor,"factor solution"),label="default",silent=FALSE,
  #          file= file.path(tabdir,paste0("transgeofac_loadings",nfactor,".tex")))
  return(factor)
  
}

names_ordered <- c("Pct water","Development Intensity",
                   "Avg.Circuity", "Dead-end Proportion", "Intersection Density",
                   "Self-loop Proportion", "Street Density", "Avg Street Length",
                   "Broadband", 
                   "Jobs-Housing Balance",
                   "Road grade", "Avg IRI",
                   "Non-attainment pollutants", 
                   "Pct Full Access Control","Pct Partial Access Control", 
                   "Pct local roads", "Pct Midsize Roads",
                   "Pct Highways" ,"Pct Truck AADT",
                   "Truck AADT per Lane Mile",
                   "Lane-miles per Sq. Km" ,
                   "Lane-meters per Capita", 
                   "Population Density", 
                   "Job Density",
                   "Pct manufacturing jobs", 
                   "Pct mining jobs",  
                   "Land use - Ag" )

transgeo_names_ordered = c("Broadband", "Non-attainment pollutants", "Land use - Ag", "Pct water",
                           "Development Intensity", "Avg. Circuity", "Dead-end Proportion", "Intersection Density", 
                           "Self-loop Proportion", "Street Density", "Avg Street Length", "Pct manufacturing jobs", 
                           "Pct mining jobs", "Avg IRI", "Pct Full Access Control", "Pct Partial Access Control", 
                           "Pct Truck AADT", "Truck AADT per Lane Mile",  "Lane-miles per Sq. Km" , "Population Density", 
                           "Job Density", "Road grade",  "Lane-meters per Capita","Jobs-Housing Balance", 
                           "Pct Highways" , "Pct local roads", "Pct Midsize Roads",
                           "Pct Trips <1.3 miles",
                           'Pct Trips 1.3-3 miles',
                           'Pct Trips 3-8 miles',
                           'Pct Trips >8 miles',
                           'Trip Source Magnitude')

transgeo_names_ordered2 = c("Broadband", "Non-attainment pollutants", "Land use - Ag", "Pct water",
                           "Development Intensity", "Avg. Circuity", "Dead-end Proportion", "Intersection Density", 
                           "Self-loop Proportion", "Street Density", "Avg Street Length", "Pct manufacturing jobs", 
                           "Pct mining jobs", "Avg IRI", "Pct Full Access Control", "Pct Partial Access Control", 
                           "Pct Truck AADT", "Truck AADT per Lane Mile",  "Lane-miles per Sq. Km" , "Population Density", 
                           "Job Density", "Road grade",  "Lane-meters per Capita","Jobs-Housing Balance", 
                           "Pct Highways" , "Pct local roads", "Pct Midsize Roads",
                           "Pct Trips <1.3 miles",
                           'Pct Trips 1.3-3 miles',
                           'Pct Trips 3-8 miles',
                           'Pct Trips >8 miles',
                           'Trip Source Magnitude',
                           'Demand Supply Burden')


plot.loadings <- function(fa_output, factor.names = NULL, names_ordered = names_ordered){
  # fa_output is the output from fa()
  # factor.names is a character vector that user can supply to rename the factors
  # use 0.25 as cutoff
  require(fields)
  loadings <- fa_output$loadings
  dat = as.matrix(data.frame(matrix(as.numeric(loadings), attributes(loadings)$dim, dimnames=attributes(loadings)$dimnames)))
  # name the factors
  if(!is.null(factor.names)){
    colnames(dat) <- factor.names
  }
  
  mycols = colorRampPalette(c(tim.colors(10)[c(1,2,3)],'white','white',tim.colors(10)[c(8,9,10)]))

  tick<- seq(-1,1,0.25)
  par(mar=c(5,10,8,2.8) + 0.1)

  plot.dat = dat[rev(rownames(dat)),]

  image(1:dim(plot.dat)[2],1:dim(plot.dat)[1],round(t(as.matrix(plot.dat)),2),col = rev(mycols(8)),zlim=c(-1,1),breaks = seq(-1,1,0.25),
      yaxt='n',xaxt='n',
      xlab='',ylab='',cex.lab=1.2,cex.axis=1.4)
  abline(v=1:(dim(plot.dat)[2])+0.5,lwd=1.5)
  box(lwd=1.5)
  #axis(3, labels = FALSE)
  ## Create some text labels
  labels <- colnames(dat)
  ## Plot x axis labels at default tick marks
  text(x=1:(dim(plot.dat)[2])-0.7,y=rep((dim(plot.dat)[1]+1),dim(plot.dat)[2]), adj = 0, pos = 4,offset = 1, srt = 50, 
       labels = labels, xpd = TRUE,cex=0.8)
  
  #mtext(colnames(dat),3,at=1:10,las=2,adj=0,cex=0.8,line = 0.5,srt = 45)
  mtext(rev(names_ordered),2,at=1:(dim(plot.dat)[1]),las=2,adj=1,cex=0.85,line = 0.5)
  abline(h=1:(dim(plot.dat)[1])+0.5,lwd=0.3)
  
}

plot.loadings2 <- function(fa_output, factor.names = NULL, names_ordered = names_ordered){
  # fa_output is the output from fa()
  # factor.names is a character vector that user can supply to rename the factors
  # use 0.3 as cutoff
  require(fields)
  loadings <- fa_output$loadings
  dat = as.matrix(data.frame(matrix(as.numeric(loadings), attributes(loadings)$dim, dimnames=attributes(loadings)$dimnames)))
  # name the factors
  if(!is.null(factor.names)){
    colnames(dat) <- factor.names
  }
  
  mycols = colorRampPalette(c(tim.colors(10)[c(1,2)],'white','white',tim.colors(10)[c(9,10)]))
  
  tick<- c(-1,-0.65,-0.3,0,0.3,0.65,1)
  par(mar=c(5,10,8,2.8) + 0.1)
  
  plot.dat = dat[rev(rownames(dat)),]
  
  image(1:dim(plot.dat)[2],1:dim(plot.dat)[1],
        round(t(as.matrix(plot.dat)),2),col = rev(mycols(6)),zlim=c(-1,1),
        breaks = tick,
        yaxt='n',xaxt='n',
        xlab='',ylab='',cex.lab=1.2,cex.axis=1.4)
  abline(v=1:(dim(plot.dat)[2])+0.5,lwd=1.5)
  box(lwd=1.5)
  #axis(3, labels = FALSE)
  ## Create some text labels
  labels <- colnames(dat)
  ## Plot x axis labels at default tick marks
  text(x=1:(dim(plot.dat)[2])-0.7,y=rep((dim(plot.dat)[1]+1),dim(plot.dat)[2]), adj = 0, pos = 4,offset = 1, srt = 50, 
       labels = labels, xpd = TRUE,cex=0.8)
  
  #mtext(colnames(dat),3,at=1:10,las=2,adj=0,cex=0.8,line = 0.5,srt = 45)
  mtext(rev(names_ordered),2,at=1:(dim(plot.dat)[1]),las=2,adj=1,cex=0.85,line = 0.5)
  abline(h=1:(dim(plot.dat)[1])+0.5,lwd=0.3)

  add.legend = F
  if(add.legend){
  image.plot(1:dim(plot.dat)[2],1:dim(plot.dat)[1],round(t(as.matrix(plot.dat)),2),col = rev(mycols(6)),zlim=c(-1,1),breaks = c(-1,-0.65,-0.3,0,0.3,0.65,1),
             horizontal=T, xlab='',legend.only = T,
             axis.args=list(at=tick,
                            labels=c('-1.00','-0.65','-0.30',
                                     '0','0.30','0.65','1.00')),
             legend.cex = 0.8)   
  }
  
  
}


plot.loadings2.old <- function(fa_output, factor.names = NULL){
  # fa_output is the output from fa()
  # factor.names is a character vector that user can supply to rename the factors
  # use 0.3 as cutoff
  loadings <- fa_output$loadings
  dat = as.matrix(data.frame(matrix(as.numeric(loadings), attributes(loadings)$dim, dimnames=attributes(loadings)$dimnames)))
  # name the factors
  if(!is.null(factor.names)){
    colnames(dat) <- factor.names
  }

  require(fields)  
  mycols = colorRampPalette(c(tim.colors(10)[c(1,2)],'white','white',tim.colors(10)[c(9,10)]))
  
  tick<- c(-1,-0.65,-0.3,0,0.3,0.65,1)
  par(mar=c(5,10,8,2.5) + 0.1)
  
  plot.dat = dat[rev(rownames(dat)),]
  
  image(1:10,1:27,round(t(as.matrix(plot.dat)),2),col = rev(mycols(6)),zlim=c(-1,1),
        breaks = c(-1,-0.65,-0.3,0,0.3,0.65,1),
        yaxt='n',xaxt='n',
        xlab='',ylab='',cex.lab=1.2,cex.axis=1.4)
  abline(v=1:10+0.5,lwd=1.5)
  box(lwd=1.5)
  #axis(3, labels = FALSE)
  ## Create some text labels
  labels <- colnames(dat)
  ## Plot x axis labels at default tick marks
  text(x=1:10-0.7,y=rep(28,10), adj = 0, pos = 4,offset = 1, srt = 70, 
       labels = labels, xpd = TRUE,cex=0.8)
  
  #mtext(colnames(dat),3,at=1:10,las=2,adj=0,cex=0.8,line = 0.5,srt = 45)
  mtext(rev(names_ordered),2,at=1:27,las=2,adj=1,cex=0.7,line = 0.5)
  abline(h=1:27+0.5,lwd=0.5)
  
}



plot.legend = F
if(plot.legend){
  #### for legend
  image.plot(1:10,1:27,round(t(as.matrix(dat)),2),col = rev(mycols(8)),zlim=c(-1,1),breaks = seq(-1,1,0.25),
             horizontal=T, xlab='',legend.only = T,
             axis.args=list(at=tick,
                            labels=c('-1.00','-0.75','-0.50',
                                     '-0.25','0','0.25','0.50','0.75','1.00')),
             legend.cex = 0.8)      

}


plot.legend = F
if(plot.legend){
  #### for legend
  require(fields)
  loadings <- factor$loadings
  dat = as.matrix(data.frame(matrix(as.numeric(loadings), attributes(loadings)$dim, dimnames=attributes(loadings)$dimnames)))
  # name the factors
  if(!is.null(factor.names)){
    colnames(dat) <- factor.names
  }
  
  mycols = colorRampPalette(c(tim.colors(10)[c(1,2)],'white','white',tim.colors(10)[c(9,10)]))
  
  tick<- c(-1,-0.65,-0.3,0,0.3,0.65,1)
  par(mar=c(5,10,8,2.8) + 0.1)
  
  plot.dat = dat[rev(rownames(dat)),]
  
  image.plot(1:dim(plot.dat)[2],1:dim(plot.dat)[1],round(t(as.matrix(plot.dat)),2),col = rev(mycols(6)),zlim=c(-1,1),breaks = c(-1,-0.65,-0.3,0,0.3,0.65,1),
             horizontal=T, xlab='',legend.only = T,
             axis.args=list(at=tick,
                            labels=c('-1.00','-0.65','-0.30',
                                     '0','0.30','0.65','1.00')),
             legend.cex = 0.8)      
  
}

reorder <- function(clustering){
  # reorder the cluster labels according to size, for comparing two clustering solutions later
  ord = order(table(clustering))
  return(ord[clustering])
}

clearspace<-function(){
  # remove all the object from global environment
  rm(list = ls(envir = .GlobalEnv),envir = .GlobalEnv)
}

# compute validity metrics for a range of k value
testK <- function(cluster.df, k.range = 2:15, method = 'kmeans'){
  # method can be kmeans or pam
  # returns the inverse dbi and asw index as a function of k
  require(clusterCrit) # for cluster internal and external validity metrics
  require(cluster)
  res = NULL
  for(k in k.range){
    set.seed(10) # so results are replicable each time
    if(method == 'kmeans'){
      reduced <-kmeans(cluster.df, k, iter.max = 1000,nstart=1000) 
    }
    
    if(method == 'pam'){
      reduced = pam(cluster.df,k)
      reduced$cluster = reduced$clustering
    }
    
    # excluding singular cluster obs when computing metrics, otherwise asw won't be computed
    freq = table(reduced$cluster)
    sig.cls = as.numeric(names(freq))[freq!=1]
    
    tmp1 = as.data.frame(intCriteria(as.matrix(cluster.df[reduced$cluster %in% sig.cls,]),
                                     reduced$cluster[reduced$cluster %in% sig.cls],"all"))
    tmp1$k = k
    rm(sig.cls)
    res = rbind(res,tmp1)
  }
  
  # get inverse dbi, so that quality maximizes the index
  res$davies_bouldin = 1/res$davies_bouldin
  return(res)
  
}



