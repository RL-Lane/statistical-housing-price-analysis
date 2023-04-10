library(shiny)
library(ggplot2)
library(dplyr)

list.files("Resources")
# Load the "train" dataset
train <- read.csv("Resources/train.csv")

train_data <- dplyr:: filter(train, Neighborhood == "Edwards" | Neighborhood == "NAmes" | Neighborhood == "BrkSide")





# Define UI
ui <- fluidPage(
  
  titlePanel("Housing Price Analysis"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      # Select the neighborhood class
      selectInput("neighborhood", "Select Neighborhood Class", choices = c("All", unique(train_data$Neighborhood)))
      
    ),
    
    mainPanel(
      
      # Display the ggplot
      plotOutput("housingPlot")
      
    )
  )
)

# Define server
server <- function(input, output) {
  
  # Define color dictionary
  color_dict <- c("NAmes" = "red", "BrkSide" = "blue", "Edwards" = "green")
  
  # Filter the dataset based on the selected neighborhood class
  filtered_data <- reactive({
    if(input$neighborhood == "All") {
      train_data
    } else {
      train_data %>% filter(Neighborhood == input$neighborhood)
    }
  })
  
  # Create the ggplot based on the filtered data
  output$housingPlot <- renderPlot({
    ggplot(filtered_data(), aes(x = GrLivArea, y = SalePrice, color = Neighborhood)) +
      geom_point() +
      scale_color_manual(values = color_dict)
  })
}


# Run the app
shinyApp(ui, server)


