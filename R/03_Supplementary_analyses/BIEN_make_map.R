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

fig_bien <-
  data_bien %>%
  dplyr::mutate(
    datasource = as.factor(datasource)
  ) %>%
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
  ggplot2::scale_fill_continuous(
    type = "viridis",
    trans = "log1p",
    breaks = c(0, 10, 100, 1e3, 1e6)
  ) +
  ggplot2::facet_wrap(~datasource) +
  ggplot2::coord_quickmap() +
  ggplot2::labs(
    title = "Spatial distribution of BIEN plot data",
    subtitle = "Faceted by data source (diffrent methodology)",
    x = "Longitude",
    y = "Latitude",
    fill = "Number of plots"
  )

ggplot2::ggsave(
  filename = here::here(
    "Outputs/Figures/BIEN_map.pdf"
  ),
  plot = fig_bien
)
