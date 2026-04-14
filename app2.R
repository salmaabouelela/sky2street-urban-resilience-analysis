# ==============================
# SKY2STREET DASHBOARD (Salma)
# ==============================

# --- Load Libraries ---
library(shiny)
library(leaflet)
library(sf)
library(dplyr)
library(ggplot2)
library(classInt)
library(scales)

# --- Load Data (adjust paths) ---
env_data <- readRDS("C:/Users/Speed/Documents/data/env_data_ready.rds") 
# (You can save your merged data as .rds from R using saveRDS(env_data, "path/env_data_ready.rds"))

# --- Define UI ---
ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      h1 {text-align: center; color: #0072B2; font-weight: bold;}
      #menu {background-color: #f0f0f0; padding: 10px; border-radius: 10px;}
      #map {height: 600px;}
    "))
  ),
  
  # Title
  h1("Sky2Street"),
  
  # Layout
  fluidRow(
    column(3,
           div(id = "menu",
               h4("📊 Select Indicator"),
               selectInput("indicator", "Choose dataset:",
                           choices = c("NDVI", "LST", "AOD", "Precipitation"),
                           selected = "NDVI"),
               
               h4("🧠 Simulation"),
               textInput("ilce", "District:", "Kadikoy"),
               textInput("mahalle", "Neighborhood:", "Fener"),
               numericInput("ndvi_delta", "Increase NDVI by:", value = 0.1, step = 0.05),
               actionButton("simulate", "Simulate Improvement"),
               
               hr(),
               h4("📍 Citizen Report"),
               textInput("name", "Your Name:"),
               textInput("issue", "Describe Issue:"),
               actionButton("submit", "Send Report")
           )
    ),
    column(9, leafletOutput("map", height = "600px"))
  ),
  
  hr(),
  plotOutput("simulation_plot", height = "300px")
)

# --- Define Server ---
server <- function(input, output, session) {
  
  # Base Map
  output$map <- renderLeaflet({
    leaflet(env_data) %>%
      addTiles() %>%
      setView(lng = 28.9784, lat = 41.0082, zoom = 10)
  })
  
  # Reactive color update
  observe({
    indicator <- input$indicator
    colname <- switch(indicator,
                      "NDVI" = "NDVI",
                      "LST" = "LST",
                      "AOD" = "AOD",
                      "Precipitation" = "Precip")
    
    pal <- colorNumeric(palette = "YlOrRd", domain = env_data[[colname]])
    
    leafletProxy("map", data = env_data) %>%
      clearShapes() %>%
      addPolygons(
        fillColor = ~pal(get(colname)),
        fillOpacity = 0.8,
        color = "white",
        weight = 1,
        popup = ~paste0("<b>", MAHALLE_AD, "</b><br>", colname, ": ", round(get(colname), 3))
      ) %>%
      addLegend(pal = pal, values = env_data[[colname]], title = indicator, opacity = 1)
  })
  
  # --- Simulation ---
  # --- Helper function ---
  simulate_ndvi_increase <- function(df, ilce, mahalle, ndvi_delta){
    ...
  }
  
  # --- Inside server ---
  server <- function(input, output, session) {
    
    ...
    
    # --- Simulation block (this part is triggered by the button) ---
    observeEvent(input$simulate, {
      isolate({
        ilce <- input$ilce
        mahalle <- input$mahalle
        delta <- input$ndvi_delta
        
        df <- env_data
        
        old_ndvi <- df$NDVI[
          tolower(iconv(df$ILCE_ADI, to = "ASCII//TRANSLIT")) == tolower(iconv(ilce, to = "ASCII//TRANSLIT")) &
            tolower(iconv(df$MAHALLE_AD, to = "ASCII//TRANSLIT")) == tolower(iconv(mahalle, to = "ASCII//TRANSLIT"))
        ]
        
        if (length(old_ndvi) == 0) {
          showNotification("⚠️ District or neighborhood not found in data.", type = "error")
          return(NULL)
        }
        
        new_ndvi <- old_ndvi + delta
        lst_model <- lm(LST ~ NDVI + I(NDVI^2), data = df)
        new_lst <- predict(lst_model, newdata = data.frame(NDVI = new_ndvi))
        
        improvement <- data.frame(
          Metric = c("Old LST", "New LST"),
          Value = c(old_ndvi, new_lst)
        )
        
        output$simulation_plot <- renderPlot({
          ggplot(improvement, aes(Metric, Value, fill = Metric)) +
            geom_bar(stat = "identity") +
            labs(title = paste("Simulated NDVI Increase in", mahalle),
                 y = "LST (°C)") +
            theme_minimal()
        })
      })
    })
    
    ...
  }
  
  # --- Citizen Report ---
  observeEvent(input$submit, {
    showNotification("✅ Your report was sent successfully! Thank you for contributing.", type = "message")
  })
}

# --- Run the App ---
shinyApp(ui, server)
