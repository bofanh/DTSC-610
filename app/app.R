#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

## Install the required package with:
## install.packages("RSocrata")



##################new data
library(dplyr)

library(DT) # library to display datatable

library(ggplot2)





# Define UI for application that draws a histogram
ui <- navbarPage(title = "DTSC 610 - M01/Spring 2022",

                #########Static Plots##########
                tabPanel("Static Plots",
                         plotOutput("statenewcasetoday"),
                         plotOutput("statenewdeathtoday"),
                         plotOutput("statestotcase"),
                         plotOutput("statestotcase2"),
                         plotOutput("statestotcase3"),
                ),
                
                #########page 2##########
                tabPanel("The Datasets",
                         h2("The CDC data"),
                         DT::dataTableOutput("mytable")
                ),
                
                #########page Read Me##########
                tabPanel("Read Me",includeMarkdown("../readme.md")
                ),
        )
# Define server logic required to draw a histogram
server <- function(input, output, session) {

    output$distPlot <- renderPlot({

        # draw the histogram with the specified number of bins
        hist(as.numeric(df[,2]), col = 'darkgray', border = 'white')
    })
        # render the table set 
        output$mytable = DT::renderDataTable({
            df
        })
        # render today's data
        tdata <- read.csv(file = 'today_dataframe.csv')
        
        output$statenewdeathtoday = renderPlot({
            ggplot(tdata, aes(state, new_death, size = tot_death,)) + 
                geom_point(alpha=0.7) +
                scale_size(range = c(.1, 16), name="Total Death")+
                ylab("Number of New Death") +
                xlab("State")
                
        })
        # New Cases
        output$statenewcasetoday = renderPlot({
            ggplot(tdata, aes(state, new_case, size = tot_cases,)) + 
                geom_point(alpha=0.7) +
                scale_size(range = c(.1, 16), name="Total Cases")+
                ylab("Number of New Cases") +
                xlab("State")+
                theme_bw()
        })
        
        # different states
        adata <- read.csv(file = 'all_dataframe.csv')
        
        output$statestotcase = renderPlot({
            ggplot(adata, aes(submission_date, tot_cases,  group=state, color =state )) +
                geom_line() +
                theme(axis.text.x=element_blank(), #remove x axis labels
                      axis.ticks.x=element_blank(), #remove x axis ticks
                ) +
                xlab("From 2019 to Present") + 
                labs(title = "Total Case Trend")+
                ylab("Daily Total Cases")
        })
        
        # different states
        output$statestotcase2 = renderPlot({
            ggplot(adata, aes(submission_date, new_case,  group=state, color =state )) +
                geom_line() +
                theme(axis.text.x=element_blank(), #remove x axis labels
                      axis.ticks.x=element_blank(), #remove x axis ticks
                ) +
                xlab("From 2019 to Present") + 
                ylab("Daily New Cases") +
                labs(title = "New Case Trend")
            
        })
        
        # different states
        output$statestotcase3 = renderPlot({
            ggplot(adata, aes(state, new_case,  fill=state )) +
                geom_line() +
                geom_bar(stat="identity", width=1) +
                coord_polar("y", start=0)+
                theme(axis.text.y=element_blank(), #remove x axis labels
                      axis.ticks.y=element_blank(), #remove x axis ticks
                ) 
            
        })

    }

# Run the application 
shinyApp(ui = ui, server = server)
