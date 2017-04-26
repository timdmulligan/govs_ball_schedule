library(shiny)
library("RSQLite")
library(plotly)
library(stringi)

# CCSP data

### BEGIN SHINY APP ###
shinyServer(function(input, output, session) {
  
#Read in Gov's Ball Data
  fest_data<-reactive({
    con = dbConnect(SQLite(), dbname="pitchfork-data-shiny.db")
    gbe <- dbGetQuery(con, "SELECT artist, popularity, followers, pf_mean AS critical,
                                   genre, day, festival 
                            FROM fest_data_enriched
                            WHERE followers > 1000")

    if (input$critical_check != T){
      gbe <- gbe[!(is.na(gbe$critical)),]
    } else {
      gbe[is.na(gbe$critical),]$critical<- mean(gbe$critical, na.rm = T)
    }

    if (input$genre_filter != "All"){
      gbe <- gbe[gbe$genre == input$genre_filter,]
    }
    
    if (input$festival_filter != "All Festivals"){
      gbe <- gbe[gbe$festival == input$festival_filter,]
    }
    gbe
  })
  
  output$myChart <- renderPlotly({
    data <- fest_data()
    #browser()
    if (input$group_filter == "Genre"){
      groupby = data$genre
    } else if (input$group_filter == "Festival"){
      groupby = data$festival
    } else {
      groupby = data$day
    }
    p <- plot_ly(x = data$critical,
                 y = data$followers,
                 color = groupby,
                 mode = "markers",
                 text = data$artist,
                 marker = list(size = 10)
                 )
    p <- layout(p,
                yaxis = list(title = 'Followers on Spotify'),
                xaxis = list(title = 'Critical Score'),
                paper_bgcolor='rgba(0,0,0,0)',
                plot_bgcolor='rgba(0,0,0,0)'
    )
  })
  
  
  output$table <- renderDataTable({
    data <- fest_data()
    data
  }, options = list(pageLength = 10), selection = "single")
  
})