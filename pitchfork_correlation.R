con = dbConnect(SQLite(), dbname="pitchfork-data-shiny.db")
gbe <- dbGetQuery(con, "SELECT artist, popularity, followers, pf_mean AS critical,
                  genre, day, festival 
                  FROM fest_data_enriched
                  WHERE pf_mean IS NOT NULL")
library(Hmisc)
rcorr(gbe$followers, gbe$critical, type="pearson")

t <- list(
  family = "overpass",
  size = 14)

p <- plot_ly(x = gbe$critical,
             y = gbe$followers,
             mode = "markers",
             marker = list(size = 10,
                           color = 'rgba(255, 182, 193, .9)',
                           line = list(color = 'rgba(152, 0, 0, .8)',
                                       width = 2)))
p <- layout(p,
            yaxis = list(title = 'Followers on Spotify'),
            xaxis = list(title = 'Average Review Score'),
            paper_bgcolor='rgba(241,241,241,241)',
            plot_bgcolor='rgba(241,241,241,241)',
            title = "Pitchfork.com doesn't really care <br>
                    how popular you are <br>
                    (n = 135, r = -0.094)",
            margin = list(t = 120, l = 80, r = 80, b = 80),
            font = t
)
p
