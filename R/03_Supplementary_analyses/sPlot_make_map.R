#----------------------------------------------------------#
#
#
#                   Vegetation data
#
#                Visualize the sPlot data
#
#
#                      O. Mottl
#                         2023
#
#----------------------------------------------------------#

# Map the spatial distribution of sPlot data


#----------------------------------------------------------#
# 1. Set up -----
#----------------------------------------------------------#

# Load configuration
source(
  here::here(
    "R/00_Config_file.R"
  )
)

#----------------------------------------------------------#
# 2. Load data  -----
#----------------------------------------------------------#

data_splot <-
  RUtilpol::get_latest_file(
    file_name = "data_splot",
    dir = here::here(
      "Data/Processed/sPlot"
    )
  )

#----------------------------------------------------------#
# 3. PLot data  -----
#----------------------------------------------------------#

fig_splot <-
  data_splot %>%
  ggplot2::ggplot(
    mapping = ggplot2::aes(
      x = Longitude,
      y = Latitude,
    )
  ) +
  ggplot2::borders(
    fill = "gray80",
    colour = NA
  ) +
  # ggplot2::geom_point() +
  ggplot2::geom_hex(bins = 90) +
  scale_fill_continuous(type = "viridis", trans = "log1p", breaks = c(0, 10, 100, 1e3)) +
  ggplot2::coord_quickmap() +
  ggplot2::labs(
    title = "Spatial distribution of sPlot data",
    x = "Longitude",
    y = "Latitude",
    fill = "Number of plots"
  )


ggplot2::ggsave(
  filename = here::here(
    "Outputs/Figures/sPlot_map.pdf"
  ),
  plot = fig_splot
)
