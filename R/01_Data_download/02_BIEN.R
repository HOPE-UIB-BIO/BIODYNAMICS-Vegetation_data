#----------------------------------------------------------#
#
#
#                   Vegetation data
#
#                  Get the BIEN data
#
#
#                      O. Mottl
#                         2023
#
#----------------------------------------------------------#
# Download data using rBIEN package


#----------------------------------------------------------#
# 1. Set up -----
#----------------------------------------------------------#

# Load configuration
source(
  here::here(
    "R/00_Config_file.R"
  )
)

download_de_novo <- FALSE

#----------------------------------------------------------#
# 2. Downloa data and save as individual files  -----
#----------------------------------------------------------#

# Get all the avaibale protocols


# There is a hack prsented at GH Issue
# https://github.com/bmaitner/RBIEN/issues/21
vec_sampling_protocols_from_occ <-
  tibble::as_tibble(
    BIEN:::.BIEN_sql(
      query = "SELECT DISTINCT sampling_protocol  FROM view_full_occurrence_individual"
    )
  ) %>%
  purrr::chuck("sampling_protocol")

# get the available protocols from package
vec_sampling_protocols_from_plot <-
  BIEN::BIEN_plot_list_sampling_protocols() %>%
  purrr::chuck("sampling_protocol")

# merge the two lists
vec_sampling_protocols <-
  c(
    vec_sampling_protocols_from_occ,
    vec_sampling_protocols_from_plot
  ) %>%
  unique() %>%
  sort()

# path to the directory
sel_path <-
  here::here(
    "Data/Input/BIEN"
  )

# download each sampling protocol and save it as individual file
purrr::walk(
  .progress = TRUE,
  .x = vec_sampling_protocols,
  .f = ~ {
    # clean name
    clean_protocol_name <-
      janitor::make_clean_names(.x)

    # trunkate the name if too long
    if (
      stringr::str_length(clean_protocol_name) >= 50
    ) {
      clean_protocol_name <-
        stringr::str_trunc(clean_protocol_name, 50, ellipsis = "__trunk")
    }

    message(clean_protocol_name)

    # check if the file is present
    is_present <-
      list.files(sel_path) %>%
      purrr::map_lgl(
        .f = ~ stringr::str_detect(.x, clean_protocol_name)
      ) %>%
      any()

    if (
      isFALSE(is_present) | isTRUE(download_de_novo)
    ) {
      # download
      data_download <-
        BIEN::BIEN_plot_sampling_protocol(
          sampling_protocol = .x,
          all.taxonomy = TRUE,
          collection.info = TRUE,
          all.metadata = TRUE
        )

      # save
      RUtilpol::save_latest_file(
        object_to_save = data_download,
        file_name = clean_protocol_name,
        dir = sel_path
      )
    }
  }
)
