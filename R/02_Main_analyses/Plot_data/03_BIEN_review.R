#----------------------------------------------------------#
#
#
#                   Vegetation data
#
#                     EDA of BIEN data
#
#
#                      O. Mottl
#                         2023
#
#----------------------------------------------------------#
# EDA bien data


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
# 3. EDA  -----
#----------------------------------------------------------#

names(data_bien)

# All splot datasets
data_bien %>%
  tidyr::drop_na(longitude, latitude, plot_area_ha) %>%
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
  ggplot2::geom_point(alpha = 0.1) +
  ggplot2::geom_density2d() +
  ggplot2::coord_quickmap()


# Get the most common size
bien_most_common_size <-
  data_bien %>%
  dplyr::distinct(
    datasource, methodology_reference,
    datasource_id, plot_name, plot_area_ha
  ) %>%
  tidyr::drop_na(plot_area_ha) %>%
  dplyr::group_by(plot_area_ha) %>%
  dplyr::count() %>%
  dplyr::arrange(desc(n)) %>%
  purrr::chuck("plot_area_ha", 1)

data_bien_same_size <-
  data_bien %>%
  dplyr::filter(
    plot_area_ha == bien_most_common_size
  ) %>%
  tidyr::drop_na(longitude, latitude)

data_bien_same_size %>%
  ggplot2::ggplot(
    mapping = ggplot2::aes(
      x = longitude,
      y = latitude,
    )
  ) +
  ggplot2::borders(
    fill = "gray80",
    colour = "gray80"
  ) +
  ggplot2::geom_point(
    alpha = 0.5
  ) +
  ggplot2::geom_density2d(
    alpha = 0.5
  ) +
  ggplot2::coord_quickmap(
    xlim = range(data_bien_same_size$longitude),
    ylim = range(data_bien_same_size$latitude)
  ) +
  ggplot2::labs(
    x = "Longitude",
    y = "Latitude",
    caption = paste(
      "plot size:", bien_most_common_size * 1e4, "m2", "\n",
      "N datasets = ", nrow(data_bien_same_size)
    )
  )
