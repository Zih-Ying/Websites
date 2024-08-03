library(shiny)
library(shinythemes)
library(shinyWidgets)
library(leaflet)
library(dplyr)
library(rlang)
library(stringr)
library(DT)
library(sf)

# data <- ndf %>% 
#   mutate(across(c(lat, lng), as.numeric)) %>% 
#   filter(!(Name %in% c("金泰公園", "光復南路58巷", "安強公園")))
# saveRDS(data, "data/data.rds")
df.tn <- readRDS("shiny data/district.rds")
data <- readRDS("shiny data/data.rds") %>% 
  mutate(time = substr(time, 1, 13))
data$col_park <- ifelse(data$nPark<median(data$nPark),0,1)
data$col_bike <- ifelse(data$nBike<median(data$nBike),0,1)

data1 <- data %>% 
  select(c(dist, Name, lat, lng)) |>
  unique()

pal <- colorFactor(
  palette = c("firebrick2", "springgreen4"),
  domain = data$col_park
)

time <- data %>% select(time) %>% 
  pull() |>
  unique()

ui <- fluidPage(
  theme = shinytheme("flatly"),
  tags$head(
    tags$style(HTML('
      td[data-type="factor"] input {
        width: 100px !important;
      }
    '))
  ),
  fluidRow(
    column(6, selectInput("variable", "Variable", choices=c("Bike","Park"))),
    column(6, br(), textOutput("median"), strong("*Red: < median; Green >= median"))
  ),
  sliderTextInput("time", "Time", choices = time, width = "90%", animate = animationOptions(interval = 800)) |>
    htmltools::tagAppendAttributes(style="margin-left:auto;margin-right:auto;"),
  leafletOutput("map", height = "600"),
  hr(),
  actionButton("remove", "Remove selected row", class="btn-danger", width="100%", style="padding: revert"),
  br(), 
  DT::dataTableOutput("table")
)

server <- function(input, output, session) {
  output$table <- DT::renderDataTable({
    DT::datatable(data1, selection = "single", filter = "top")
  })
  highlight_icon = makeAwesomeIcon(icon = 'flag')
  prev_row <- reactiveVal()
  observeEvent(input$table_rows_selected, {
    row_selected = data1[input$table_rows_selected, ]
    proxy <- leafletProxy('map')
    # Reset previously selected marker
    if(!is.null(prev_row())){
      proxy %>%
        removeMarker("selected")
    }
    proxy %>%
      setView(lng=row_selected$lng, lat=row_selected$lat, zoom=18) %>% 
      addAwesomeMarkers(popup = as.character(row_selected$Name),
                        layerId = "selected",
                        lng = row_selected$lng, 
                        lat = row_selected$lat,
                        icon = highlight_icon)
    
    # set new value to reactiveVal 
    prev_row(row_selected)
  })
  tmp <- reactiveValues(click=F)
  observeEvent(input$remove, {
    req(input$table_rows_selected)
    tmp$click=T
    if(tmp$click==T){
      leafletProxy('map') %>% 
        removeMarker("selected")
    }
    tmp$click=F
  })
  
  sliderData <- reactive({
    data %>%
      filter(time == input$time)
  })
  output$median <- renderText({
    tmp <- sliderData() %>% 
      pull(paste0("n", input$variable))
    paste(input$variable, "Median number: ", median(tmp))
  })
  
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(lng=121.5598, lat=25.09108, zoom=12) %>% 
      addPolygons(data=df.tn, weight = 2, fill = F) 
  })
  
  observe({
    tmp <- sliderData() %>% 
      pull(paste0("n", input$variable)) |>
      median()
    expr <- paste0("new = abs(n", input$variable,"-tmp)")
    col_name <- trimws(str_extract(expr,"[^=]+"))
    
    dat <- sliderData() %>%
      # dplyr::mutate(!!rlang::parse_expr(expr))
      dplyr::mutate(!!col_name := !!rlang::parse_expr(expr))
    
    # output$test <- renderPrint(dat)
    leafletProxy("map", data = dat) %>%
      clearMarkers() %>%
      addCircleMarkers(
        lng = ~ lng, lat = ~ lat,
        radius = ~new,
        weight = 3, popup = ~Name,
        color = ~pal(col_park)
      )
  })
}

shinyApp(ui, server)