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

library("RSocrata")

df <- read.socrata(
    "https://data.cdc.gov/resource/9mfq-cb36.json",
    app_token = "EBMs4oKetmLbVamIOVl7e9bP3",
    email     = "bhe@nyit.edu",
    password  = "Ilovecoding1"
)

library(DT) # library to display datatable
library(leaflet) # interactive map function

library(usmap)
library(ggplot2)

# Define UI for application that draws a histogram
ui <- navbarPage(title = "DTSC 610 - M01/Spring 2022",
                 #########page 1##########
                 tabPanel("Page 1",
                    fluidPage(
                
                    # Application title
                    titlePanel("US Covid Data"),
                
                
                        # Show a plot of the generated distribution
                        mainPanel(
                           plotOutput("distPlot")
                        )
                    )
                ),

                #########us covid Map##########
                tabPanel("US Covid-19 Map",
                         ),
                
                
                #########page Interactive Map##########
                tabPanel("Interactive Map",
                         div(class="outer",
                             
                             tags$head(
                                 # Include our custom CSS
                                 includeCSS("styles.css"),
                             ),
                             
                             leafletOutput("covidmap", width="100%", height="100%"),
                             
                             # Shiny versions prior to 0.11 should use class = "modal" instead.
                             absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                           draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                                           width = 330, height = "auto",
                                           
                                           h3("COVID-19 explorer"),
                                           )
                        
                ),
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
        
        # render interactive map
        output$covidmap <- renderLeaflet({
            leaflet() %>%
                addTiles() %>%
                setView(lng = -93.85, lat = 37.45, zoom = 5)
            # generate the map
        })
        
        # render us covid map

    }

# Run the application 
shinyApp(ui = ui, server = server)
