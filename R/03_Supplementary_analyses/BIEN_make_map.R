#----------------------------------------------------------#
#
#
#                   Vegetation data
#
#                Visualize the BEIN data
#
#
#                      O. Mottl
#                         2023
#
#----------------------------------------------------------#

# Map the spatial distribution of BIEN data


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

data_bien <-
  RUtilpol::get_latest_file(
    file_name = "data_bien",
    dir = here::here(
      "Data/Processed/BIEN"
    )
  )

#----------------------------------------------------------#
# 3. PLot data  -----
#----------------------------------------------------------#


dplyr::glimpse(data_bien)

fig_bien <-
  data_bien %>%
  ggplot2::ggplot(
    mapping = ggplot2::aes(
      x = longitude,
      y = latitude,
    )
  ) +
  ggplot2::borders(
    fill = "gray80",
    colour = NA
  ) +
  # ggplot2::geom_point() +
  ggplot2::geom_hex(bins = 90) +
  scale_fill_continuous(type = "viridis") +
  ggplot2::coord_quickmap() +
  ggplot2::labs(
    title = "Spatial distribution of BIEN plot data",
    x = "Longitude",
    y = "Latitude",
    fill = "Number of plots"
  )


ggplot2::ggsave(
  filename = here::here(
    "Outputs/Figures/BIEN_map.pdf"
  ),
  plot = fig_splot
)
