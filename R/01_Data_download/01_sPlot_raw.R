#----------------------------------------------------------#
#
#
#                   Vegetation data
#
#                    Get the sPlot data
#
#
#                      O. Mottl
#                         2023
#
#----------------------------------------------------------#
# Process the sPlotOpen data raw data and save as individual files


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

# Dataset link:
#  https://idata.idiv.de/ddm/Data/ShowData/3474?version=76

# Processing of the sPlot
#  https://github.com/fmsabatini/sPlotOpen_Code

# Manuscript link :
#   https://onlinelibrary.wiley.com/doi/10.1111/geb.13346#geb13346-bib-0014


base::load(
  here::here(
    "Data/Input/sPlot/Raw/sPlotOpen.RData"
  )
)


#----------------------------------------------------------#
# 3. Save as individual files  -----
#----------------------------------------------------------#

RUtilpol::save_latest_file(
  object_to_save = DT2.oa,
  file_name = "data_splot_taxa",
  dir = here::here(
    "Data/Input/sPlot"
  )
)

RUtilpol::save_latest_file(
  object_to_save = header.oa,
  file_name = "data_splot_meta",
  dir = here::here(
    "Data/Input/sPlot"
  )
)
