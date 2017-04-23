library(shiny)
library("RSQLite")
library(plotly)
library(stringi)

# CCSP data

### BEGIN SHINY APP ###
shinyServer(function(input, output, session) {
  
#Read in Gov's Ball Data
  gbe_data<-reactive({
    con = dbConnect(SQLite(), dbname="pitchfork-data-shiny.db")
    gbe <- dbGetQuery(con, "SELECT artist, popularity, pf_mean + pf_count AS critical, genre, day  
                            FROM govs_ball_enriched")
    gbe[is.na(gbe$critical),]$critical<- mean(gbe$critical, na.rm = T)
    if (input$genre_filter != "All"){
      gbe <- gbe[gbe$genre == input$genre_filter,]
    }
    gbe
  })
  
  output$myChart <- renderPlotly({
    data <- gbe_data()
    #browser()
    if (input$group_filter == "Genre"){
      groupby = data$genre
    } else {
      groupby = data$day
    }
    p <- plot_ly(x = data$popularity,
                 y = data$critical,
                 color = groupby,
                 mode = "markers",
                 text = data$artist,
                 marker = list(size = 10)
                 )
    p <- layout(p,
                yaxis = list(title = 'Critical Score'),
                xaxis = list(title = 'Popularity'),
                paper_bgcolor='rgba(0,0,0,0)',
                plot_bgcolor='rgba(0,0,0,0)'
    )
  })
  
  
  output$table <- renderDataTable({
    data <- gbe_data()
    data
  }, options = list(pageLength = 10), selection = "single")
  
})