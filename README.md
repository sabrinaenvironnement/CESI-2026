# CESI-2026
Scripts to calculate the Canadian Environmental Sustainability Indicators for water quantity for 2026. Starting in the 2024-2025 work plan, HSU is improving the CESI water quantity indicator.

The R scripts for the water quantity indicator have been reviewed to include a control file. Within the control file, the year selected for the analysis can be identified and the calculation can be completed with the scipts below. 
          o CESI_Control file_2024

Current R scripts are in two sets: • Functions scripts build on the work started by Joe. They are modular functions that are used for more than one indicator. 
          o CESI data sorting functions 
          o CESI indicator functions 
          o CESI trend functions 
          o CESI mapping functions

• Indicator scripts that call on the various functions to calculate indicator and make products used in narrative started by Sarah. Each includes a list of the CESI function files called on. 
          o CESI étiage 
          o CESI crue 
          o CESI rendement 
          o CESI statistiques > this uses output from previous three to calculate statistics and make summary figures included in the narrative

All CESI indicators use the same colour palette, as described in the document CESI_Colour_Palette.pdf. The functions above use these colours.


