# Histogram with ggplot2
# minimum viable re-expression
library(shiny)
# Define UI for application that draws a histogram
histui <- fluidPage(

   # Application title
   titlePanel("Old Faithful Geyser Data"),

   # Sidebar with a slider input for number of bins
   sidebarLayout(
      sidebarPanel(
        sliderInput("raiser_power",
                    "Select Power:",
                    min = .1,
                    max = 3,
                    value = 1),
        sliderInput("bins",
                    "Select Bin Width:",
                    min = .1,
                    max = 10,
                    value = 2)
      ),
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot")
      )
   )
)

# Define server logic required to draw a histogram
histserver <- function(input, output) {
  library(ggplot2)
  library(tidyverse)
  plot_data <- reactive({
    re_expressed <- data_frame(constant = 1, to_plot = (faithful$waiting ^ input$raiser_power ))
    mean_time_val <-  mean(re_expressed$to_plot)
    median_time_val <-  median(re_expressed$to_plot)
    re_expressed <- re_expressed %>% mutate(
    mean_time = mean_time_val,
    median_time = median_time_val
    )
    return(re_expressed)
  })
  # vline_labels <- paste0("Mean (red): ", round(mean_time, 2), "; Median (green): ", round(median_time, 2))
  output$distPlot <- renderPlot(
    ggplot(plot_data(), aes(to_plot)) +
      geom_histogram(binwidth = input$bins) +
      ggtitle("Old Faithful intervals in minutes.")
      # geom_vline(xintercept = mean_time, color = "dark red")
      # annotate("text", label = paste("Mean: ", round(mean_time,digits = 2)), x = mean_time, y = 30, color = "dark red", size = 5) +
      # geom_vline(xintercept = median_time, color = "green") +
      # annotate("text", label = paste("Median: ", round(median_time,digits = 2)), x = mean_time, y = 35, color = "dark red", size = 5)
    # labs(caption = vline_labels)
   )
}

# Run the application
shinyApp(ui = histui, server = histserver)
