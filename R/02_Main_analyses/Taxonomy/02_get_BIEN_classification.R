#----------------------------------------------------------#
#
#
#                   Vegetation data
#
#                taxa classification - BIEN data
#
#
#                      O. Mottl
#                         2023
#
#----------------------------------------------------------#
# get full classiifcation for BIEN data


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

data_taxa_raw <-
  RUtilpol::get_latest_file(
    file_name = "taxa_list_raw",
    dir = here::here(
      "Data/Processed/BIEN"
    )
  )


#----------------------------------------------------------#
# 3. Process data  -----
#----------------------------------------------------------#

# set number of taxa to bin data by
n_taxa_bulk <- 50

# nest data
taxa_table_raw_nested <-
  bin_taxonomic_data(
    data_taxa_raw,
    name_matched,
    n_taxa_bulk
  )

if (
  here::here(
    "Data/Temp/classification_bien"
  ) %>%
    list.files() %>%
    length() == 0
) {
  # get classification for all taxa in a bin and save
  classify_and_save_taxa_bins(
    taxa_table_raw_nested,
    "name_matched",
    dir = here::here(
      "Data/Temp/classification_bien"
    )
  )
}

# load data
data_reference_table_class <-
  get_all_data_as_df(
    here::here(
      "Data/Temp/classification_bien"
    )
  )

# merge data into harmonisation table
data_taxa_harmonised <-
  dplyr::left_join(
    data_taxa_raw,
    data_reference_table_class,
    by = dplyr::join_by("name_matched" == "sel_name")
  ) %>%
  dplyr::mutate(
    taxon_harmonised = purrr::map_chr(
      .x = classification,
      .f = ~ {
        if (
          is.null(.x)
        ) {
          return(NA_character_)
        }

        .x %>%
          dplyr::slice_tail(n = 1) %>%
          purrr::chuck("name") %>%
          return()
      }
    )
  ) %>%
  dplyr::select(
    name_matched,
    taxon_harmonised,
    classification
  )

# save results
RUtilpol::save_latest_file(
  object_to_save = data_taxa_harmonised,
  file_name = "data_taxa_classification",
  dir = here::here(
    "Data/Processed/BIEN"
  )
)
