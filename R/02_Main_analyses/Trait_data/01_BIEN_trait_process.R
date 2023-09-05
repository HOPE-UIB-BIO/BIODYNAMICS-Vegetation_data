#----------------------------------------------------------#
#
#
#                   Vegetation data
#
#                Process the BIEN data
#
#
#                      O. Mottl
#                         2023
#
#----------------------------------------------------------#
# Process the BIEN to save as one file with relevant data


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

data_bien_files <-
  here::here(
    "Data/Input/BIEN/Trait_data"
  ) %>%
  list.files() %>%
  purrr::map(
    .f = ~ RUtilpol::get_clean_name(.x)
  ) %>%
  unique() %>%
  rlang::set_names() %>%
  purrr::map(
    .f = ~ RUtilpol::get_latest_file(
      file_name = .x,
      dir = here::here(
        "Data/Input/BIEN/trait_data"
      )
    )
  )

#----------------------------------------------------------#
# 3. Process data  -----
#----------------------------------------------------------#

data_bien_raw <-
  data_bien_files %>%
  # discard the NA
  purrr::discard(
    .p = ~ is.na(.x) %>% all()
  ) %>%
  # discard the empty
  purrr::discard(
    .p = ~ is.null(.x)
  ) %>%
  # discard the 0 row dataframe
  purrr::discard(
    .p = ~ nrow(.x) < 1
  ) %>%
  # merge the files
  dplyr::bind_rows() %>%
  tibble::as_tibble()
janitor::clean_names()


data_bien_raw %>%
  dplyr::slice(1:1e3) %>%
  names()

data_bien <-
  data_bien_raw %>%
  dplyr::select(
    dplyr::any_of(
      c(
        "trait_name",
        "trait_value",
        "unit",
        "longitude",
        "latitude",
        "family_matched",
        "name_matched",
        "name_matched_author",
        "verbatim_family",
        "verbatim_scientific_name",
        "scrubbed_species_binomial",
        "scrubbed_taxonomic_status",
        "scrubbed_family",
        "scrubbed_author"
      )
    )
  ) %>%
  dplyr::group_by(
    trait_name
  ) %>%
  tidyr::nest(
    species_data = c(
      scrubbed_species_binomial,
      trait_value,
      unit,
      longitude,
      latitude,
      family_matched,
      name_matched,
      name_matched_author,
      verbatim_family,
      verbatim_scientific_name,
      scrubbed_taxonomic_status,
      scrubbed_family,
      scrubbed_author
    )
  ) %>%
  dplyr::ungroup()

# data check -----

data_bien_unnest <-
  data_bien %>%
  tidyr::unnest(species_data)

dplyr::glimpse(data_bien_unnest)

data_bien_unnest %>%
  dplyr::mutate(
    dplyr::across(
      tidyselect::where(is.character),
      as.factor
    )
  ) %>%
  summary()

# check the percentage of NAs in each column
(data_bien_unnest %>%
  is.na() %>%
  colSums() / nrow(data_bien_unnest)) * 100


#----------------------------------------------------------#
# 4. Save  -----
#----------------------------------------------------------#


RUtilpol::save_latest_file(
  object_to_save = data_bien,
  file_name = "data_traits_bien",
  dir = here::here(
    "Data/Processed/BIEN"
  ),
  prefered_format = "qs",
  preset = "archive"
)


RUtilpol::save_latest_file(
  object_to_save = data_bien,
  file_name = "data_traits_bien",
  dir = here::here(
    "Data/Processed/BIEN"
  ),
  prefered_format = "qs",
  preset = "archive"
)
