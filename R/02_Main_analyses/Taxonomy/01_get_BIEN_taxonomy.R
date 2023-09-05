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

data_bien <-
  RUtilpol::get_latest_file(
    file_name = "data_bien",
    dir = here::here(
      "Data/Processed/BIEN"
    )
  )


#----------------------------------------------------------#
# 3. Process data  -----
#----------------------------------------------------------#

data_subset <-
  data_bien %>%
  dplyr::filter(
    datasource %in% c(
      "FIA", "SALVIAS"
    )
  )

data_taxa_raw <-
  data_subset %>%
  tidyr::unnest(plot_data) %>%
  dplyr::distinct(name_matched) %>%
  dplyr::arrange(name_matched)

#----------------------------------------------------------#
# 4. Save  -----
#----------------------------------------------------------#

RUtilpol::save_latest_file(
  object_to_save = data_taxa_raw,
  file_name = "taxa_list_raw",
  dir = here::here(
    "Data/Processed/BIEN"
  ),
  prefered_format = "csv",
)


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
      "Data/Temp/classification_neotoma"
    )
  )

# merge data into harmonisation table
data_taxa_harmonised <-
  dplyr::left_join(
    taxa_reference_table,
    data_reference_table_class,
    by = dplyr::join_by("neotoma_names" == "sel_name")
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
    neotoma_names,
    taxon_name,
    taxon_harmonised,
    classification
  )
