#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)
library(purrr)

generatePoints<-function(marker=NA,sd=1,inix=NA,iniy=NA,npoints=20){
  if(is.na(inix)){
    inix<-runif(1,-10,10)
  }
  if(is.na(iniy)){
    iniy<-runif(1,-10,10)
  }
  g1<-data.frame(V1=sd*rnorm(1)*sin(2*pi*runif(npoints))+inix,
                 V2=sd*rnorm(1)*cos(2*pi*runif(npoints))+iniy)
  if(!is.na(marker)){
    g1$V3<-marker
  }
  g1
}

# Define server logic
shinyServer(function(input, output) {
  
  output$text1<-renderPlot({
    set.seed(input$seed)
    
    g1<-map_df(.x = 1:input$numbergroups,generatePoints)
    g1$V3<-as.factor(g1$V3)
    g1$icon<-"point"
    g2<-g1[sample(seq_along(g1$V1),input$numbercenters),]
    g2$icon<-"star"
    q1<-g2$clase<-g2$V3<-as.factor(1:input$numbercenters)
    aguardar<-list()
    for(w in 1:10){
      if(w!=1){
        g2<-pointsmin %>%group_by(clase) %>% summarise(V1=mean(V1),V2=mean(V2))
      }
      g2$V3<-g2$clase
      for (i in g2$V3){
        g1[,i]<-(g1$V1-g2$V1[g2$V3==i])^2+(g1$V2-g2$V2[g2$V3==i])^2
      }
      qq<-q1 %in% g2$V3
      pointsmin<-g1 %>%select(V1,V2,one_of(q1[qq]%>%as.character())) %>%
        gather(clase,dista,one_of(q1[qq]%>%as.character())) %>%
        group_by(V1,V2) %>% summarise(dista=min(dista))
      g1$clase<-g1$dista<-NULL
      g1<-g1 %>% gather(clase,dista,one_of(q1[qq]%>%as.character()))
      pointsmin<-left_join(pointsmin,g1,by=c("V1","V2","dista"))
      g1<-pointsmin
      g1a<-g1
      g1a$icon="point"
      g1a$dista<-g1a$V3<-NULL
      g2a<-g2
      g2a$icon="star"
      g1a<-select(as.data.frame(g1a),V1,V2,icon,clase)
      g2a<-select(g2a,V1,V2,icon,clase)
      aguardar[[w]]<-rbind(g1a,g2a)
    }
    
    ggplot(aes(x=V1,y=V2,color=clase,shape=icon,size=icon),data=aguardar[[input$iterationnum]])+geom_point()
    })
    
  
  
})
