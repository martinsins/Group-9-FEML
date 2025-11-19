library(dplyr)
library(ggplot2)

# make sure folders exist
dir.create("Analysis", showWarnings = FALSE)
dir.create("Analysis/figs", showWarnings = FALSE)

# PROPERTY
g_property <- panel %>%
  group_by(state, year) %>%
  summarize(property_rate_100k = mean(property_rate_100k, na.rm = TRUE),
            .groups = "drop") %>%
  ggplot(aes(x = year, y = property_rate_100k, color = state)) +
  geom_line(size = 1.2) +
  geom_vline(xintercept = 1977, linetype = "dashed", color = "red") + 
  geom_vline(xintercept = 1983, linetype = "dashed", color = "blue") +
  labs(title = "Raw Property Crime Trends by State",
       subtitle = "Dotted lines = Illinois (1977) and Michigan (1983) party switches",
       x = "Year", y = "Crime Rate per 100k") +
  theme_minimal(base_size = 14)
g_property

ggsave("Analysis/figs/raw_property_trends.png",
       g_property, width = 10, height = 7)

g_violent <- panel %>%
  group_by(state, year) %>%
  summarize(violent_rate_100k = mean(violent_rate_100k, na.rm = TRUE),
            .groups = "drop") %>%
  ggplot(aes(x = year, y = violent_rate_100k, color = state)) +
  geom_line(size = 1.2) +
  geom_vline(xintercept = 1977, linetype = "dashed", color = "red") + 
  geom_vline(xintercept = 1983, linetype = "dashed", color = "blue") +
  labs(title = "Raw Violent Crime Trends by State",
       subtitle = "Dotted lines = Illinois (1977) and Michigan (1983) party switches",
       x = "Year", y = "Crime Rate per 100k") +
  theme_minimal(base_size = 14)
g_violent
ggsave("Analysis/figs/raw_violent_trends.png",
       g_violent, width = 10, height = 7)

g_total <- panel %>%
  group_by(state, year) %>%
  summarize(total_rate_100k = mean(total_rate_100k, na.rm = TRUE),
            .groups = "drop") %>%
  ggplot(aes(x = year, y = total_rate_100k, color = state)) +
  geom_line(size = 1.2) +
  geom_vline(xintercept = 1977, linetype = "dashed", color = "red") + 
  geom_vline(xintercept = 1983, linetype = "dashed", color = "blue") +
  labs(title = "Raw Total Crime Trends by State",
       subtitle = "Dotted lines = Illinois (1977) and Michigan (1983) party switches",
       x = "Year", y = "Crime Rate per 100k") +
  theme_minimal(base_size = 14)
g_total
ggsave("Analysis/figs/raw_total_trends.png",
       g_total, width = 10, height = 7)


