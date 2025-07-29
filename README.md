README: Stata Analysis of UNICEF & WPP Data
This document provides a comprehensive overview of the Stata .do file (UNICEF Test.do), which processes, merges, and analyzes data from UNICEF and the World Population Prospects (WPP) to explore relationships between maternal health services and progress toward child mortality goals.

Project Goal
The primary goal of this script is to investigate whether countries that are "on-track" to meet under-5 mortality rate (U5MR) targets have a higher number of births covered by key maternal health interventions—specifically, at least four antenatal care visits (ANC4) and skilled birth attendants (SBA)—compared to countries that are "off-track".

File Dependencies
To run this script successfully, you must have the following files located in the same directory as the .do file:

GLOBAL.xlsx: The core UNICEF dataset containing indicators for various countries. (Originally named fusion_GLOBAL_DATAFLOW_UNICEF_1.0_all.xlsx).

Track.xlsx: A tracker file that categorizes countries as "Achieved," "On-track," or "Off-track" in meeting U5MR goals.

WPP2022.xlsx: The World Population Prospects 2022 data, used to get projected birth numbers for weighting the analysis.
