etable(
  list(
    "TWFE Violent Crime"  = twfe_violent,
    "TWFE Property Crime" = twfe_property,
    "TWFE Total Crime"    = twfe_total
  ),
  tex = TRUE,
  file = "Analysis/tables/twfe_results.tex"
)
etable(
  list(
    "ES Violent Crime"  = es_violent,
    "ES Property Crime" = es_property,
    "ES Total Crime"    = es_total
  ),
  tex = TRUE,
  file = "Analysis/tables/event_study_results.tex"
)
etable(
  list(
    "S&A Violent Crime"  = sa_violent,
    "S&A Property Crime" = sa_property,
    "S&A Total Crime"    = sa_total
  ),
  tex = TRUE,
  file = "Analysis/tables/sa_results.tex"
)

### TO LOAD IN LATEX 
#\input{Analysis/tables/twfe_results.tex}
#\input{Analysis/tables/event_study_results.tex}
#\input{Analysis/tables/sa_results.tex}

ggsave("Analysis/figs/raw_property_trends.png", g_property, width = 10, height = 7)
ggsave("Analysis/figs/raw_violent_trends.png",  g_violent,  width = 10, height = 7)
ggsave("Analysis/figs/raw_total_trends.png",    g_total,    width = 10, height = 7)
png("Analysis/figs/es_violent.png", width = 900, height = 700)
iplot(es_violent)
dev.off()

png("Analysis/figs/es_property.png", width = 900, height = 700)
iplot(es_property)
dev.off()

png("Analysis/figs/es_total.png", width = 900, height = 700)
iplot(es_total)
dev.off()
png("Analysis/figs/sa_violent.png", width = 900, height = 700)
iplot(sa_violent,
      main = "Sun & Abraham: Violent Crime",
      xlab = "Event time",
      ylab = "Effect on violent crime rate per 100k")
dev.off()

png("Analysis/figs/sa_property.png", width = 900, height = 700)
iplot(sa_property,
      main = "Sun & Abraham: Property Crime",
      xlab = "Event time",
      ylab = "Effect on property crime rate per 100k")
dev.off()

png("Analysis/figs/sa_total.png", width = 900, height = 700)
iplot(sa_total,
      main = "Sun & Abraham: Total Crime",
      xlab = "Event time",
      ylab = "Effect on total crime rate per 100k")
dev.off()

###TO LOAD IN LATEX 
#\begin{figure}[H]
#\centering
#\includegraphics[width=0.9\textwidth]{Analysis/figs/es_total.png}
#\caption{Event Study: Total Crime vs Governor Party}
#\end{figure}