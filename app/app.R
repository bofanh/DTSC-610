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



# Define UI for application that draws a histogram
ui <- navbarPage(title = "DTSC 610 - M01/Spring 2022",
                 #########page 1##########
                 tabPanel("Page 1",
                    fluidPage(
                
                    # Application title
                    titlePanel("Old Faithful Geyser Data"),
                
                    # Sidebar with a slider input for number of bins 
                    sidebarLayout(
                        sidebarPanel(
                            sliderInput("bins",
                                        "Number of bins:",
                                        min = 1,
                                        max = 50,
                                        value = 30)
                        ),
                
                        # Show a plot of the generated distribution
                        mainPanel(
                           plotOutput("distPlot")
                        )
                    )
                )
                ),    
                #########page Read Me##########
                tabPanel("Interactive Map",
                         fluidPage(
                             leafletOutput("covidmap", width=2000, height=1000)
                         )
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
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
        
        # render the table set 
        output$mytable = DT::renderDataTable({
            df
        })
        
        # render interactive map
        output$covidmap <- renderLeaflet({
            leaflet() %>%
                addTiles() %>%
                setView(lng = -93.85, lat = 37.45, zoom = 4)
            # generate the map
        })
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
