#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("K means visual demostration"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       numericInput("seed","Choose an Example",value=1990,min=1,max=3000,step=1),
       sliderInput("iterationnum",
                   "Number of Iteration:",
                   min = 1,
                   max = 10,
                   value = 1),
      
       sliderInput("numbergroups",
                 "Number of Generated Groups:",
                 min=1,
                 max=10,
                 value=3),
       sliderInput("numbercenters",
                   "Number of center:",
                   min=1,
                   max=10,
                   value=3)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      h4("This is a visual tool to expore th k means algorithm,
         choose an example and the number of groups to simulate and the number of
         centers to use in the algoritm, move the slider iterations to see the method run"),
       plotOutput("text1")
    )
  )
))
