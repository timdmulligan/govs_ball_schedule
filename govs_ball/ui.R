#ui.R
library(DT)
library(shiny)
library(plotly)
library(shinythemes)
# deployApp("govs_ball_schedule/govs_ball/", appName = "govs_ball")

shinyUI(fluidPage(
  theme = shinytheme("flatly"),
  
  navbarPage(
    "Summer Music Festivals",
    #position = 'fixed-top',
    #collapsible = TRUE,
    tabPanel("Gov's Ball",
             sidebarLayout(
               sidebarPanel(
                 h2("Use ", strong("data"), "to make sure your festival experiance", em("rocks")),
                 p("With dozens of bands to choose from, picking a lineup to see can be a stressful experiance.
                   This app leverages data crawled from Pitchfork and Spotify to help you prepare."),
                 p(""),
                 selectInput(
                   "festival_filter",
                   "Select a Festival:",
                   choices = list("All Festivals", "Governor's Ball", "Bonnaroo", "Lollapalooza")
                 ),
                 selectInput(
                   "group_filter",
                   "Group Chart Markers By:",
                   choices = list("Genre", "Day", "Festival")
                 ),
                 selectInput(
                   "genre_filter",
                   "Genre",
                   choices = list("All",
                                  "Metal",
                                  "Rap",
                                  "Rock/Indie",
                                  "Pop/R&B",
                                  "Electronic")
                 ),
                 checkboxInput("critical_check", label = "Include Non-Reviewed Artists", value = F),
                 downloadButton('downloadData', 'Download')
               ),
               mainPanel(
                 plotlyOutput("myChart"),
                 dataTableOutput(outputId = "table")
               )
             ))
  )
))
