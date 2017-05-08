library("RSQLite")
library(plotly)
library(Hmisc)
Sys.setenv("plotly_username"="USERNAME")
Sys.setenv("plotly_api_key"="API KEY")

setwd("~/govs_ball_schedule/")
con = dbConnect(SQLite(), dbname="pitchfork-data.db")
gbe <- dbGetQuery(con, "SELECT *
                        FROM correlation_table
                        WHERE popularity != 0
                            AND score != 0
                  ")

rcorr(gbe$log_followers, gbe$score, type="pearson")
rcorr(gbe$followers, gbe$score, type="pearson")
rcorr(gbe$popularity, gbe$score, type="pearson")

t <- list(
  family = "overpass",
  size = 14)

a <- list(
  list(
    y = gbe[gbe$artist %in% c("THE BEATLES"),]$score,
    x = gbe[gbe$artist %in% c("THE BEATLES"),]$popularity,
    text = c( "THE BEATLES"),
    xref = "x",
    yref = "y",
    showarrow = TRUE,
   arrowhead =6,
    ax = 0,
    ay = -40
   ),
  list(
    y = gbe[gbe$artist %in% c("DRAKE"),]$score,
    x = gbe[gbe$artist %in% c("DRAKE"),]$popularity,
    text = c( "DRAKE"),
    xref = "x",
    yref = "y",
    showarrow = TRUE,
    arrowhead =6,
    ax = 20,
    ay = -30
  ),
  list(
    y = gbe[gbe$artist %in% c("THE CHAINSMOKERS"),]$score,
    x = gbe[gbe$artist %in% c("THE CHAINSMOKERS"),]$popularity,
    text = c( "THE CHAINSMOKERS"),
    xref = "x",
    yref = "y",
    showarrow = TRUE,
    arrowhead =6,
    ax = 20,
    ay = 35
  ),
  list(
    y = gbe[gbe$artist %in% c("CHANCE THE RAPPER"),]$score,
    x = gbe[gbe$artist %in% c("CHANCE THE RAPPER"),]$popularity,
    text = c( "CHANCE THE RAPPER"),
    xref = "x",
    yref = "y",
    showarrow = TRUE,
    arrowhead =6,
    ax = 80,
    ay = -25
  )
)

p <- plot_ly(y = gbe$score,
             x = gbe$popularity,
             text = gbe$artist,
             mode = "markers",
             marker = list(size = 2,
                           color = 'rgba(255, 182, 193, .9)',
                           line = list(color = 'rgba(152, 0, 0, .8)',
                                       width = 1.5)))
p <- layout(p,
            xaxis = list(title = 'Followers on Spotify <br> (Log)'),
            yaxis = list(title = 'Mean Review Score'),
            paper_bgcolor='rgba(241,241,241,241)',
            plot_bgcolor='rgba(241,241,241,241)',
            title = "Pitchfork.com reviews aren't<br>
                    influenced by popularity <br>
                    (n = 6,910, r = -0.02)",
            margin = list(t = 120, l = 80, r = 80, b = 80),
            font = t,
            annotations = a
)
plotly_POST(p, filename = "pitchfork")
p




#Popularity Vs. Followers
p <- plot_ly(x = gbe$popularity,
             y = gbe$log_followers,
             mode = "markers",
             text = gbe$artist,
             marker = list(size = 2,
                           color = 'rgba(255, 182, 193, .9)',
                           line = list(color = 'rgba(152, 0, 0, .8)',
                                       width = 1.5)))
p <- layout(p,
            yaxis = list(title = 'Followers on Spotify (Log)'),
            xaxis = list(title = 'Popularity Score'),
            paper_bgcolor='rgba(241,241,241,241)',
            plot_bgcolor='rgba(241,241,241,241)',
            title = "Understanding the 'Popularity' Metric",
            margin = list(t = 120, l = 80, r = 80, b = 80),
            font = t
)


p

# Followers Hist
p <- plot_ly(x = gbe$followers,
             type = "histogram",
             mode = "markers",
             marker = list(size = 2,
                           color = 'rgba(255, 182, 193, .9)',
                           line = list(color = 'rgba(152, 0, 0, .8)',
                                       width = 1.5)))
p <- layout(p,
            yaxis = list(title = 'Count'),
            xaxis = list(title = 'Followers'),
            paper_bgcolor='rgba(241,241,241,241)',
            plot_bgcolor='rgba(241,241,241,241)',
            title = "Followers Distribution",
            margin = list(t = 120, l = 80, r = 80, b = 80),
            font = t
)


p

# Followers log Hist
p <- plot_ly(x = gbe$log_followers,
             type = "histogram",
             mode = "markers",
             marker = list(size = 2,
                           color = 'rgba(255, 182, 193, .9)',
                           line = list(color = 'rgba(152, 0, 0, .8)',
                                       width = 1.5)))
p <- layout(p,
            yaxis = list(title = 'Count'),
            xaxis = list(title = 'Log Followers'),
            paper_bgcolor='rgba(241,241,241,241)',
            plot_bgcolor='rgba(241,241,241,241)',
            title = "Log Followers Distribution",
            margin = list(t = 120, l = 80, r = 80, b = 80),
            font = t
)


p


dbGetQuery(con, "SELECT avg(score)
                        FROM correlation_table
                  ")
