**Change the directory if you must and make sure all the files are accessable. 
cd "C:\Users\tezik\Desktop\Stata test stuff"
*Hopefully you've looked at all the file and know what your're downloading file and know what youre getting into.

**here, i've imported the fusion_GLOBAL_DATAFLOW_UNICEF_1.0_all. xlsx file. note that I have it named as GLOBAL for conviencience.

clear
*I find it useful to clear stata at this point.

import excel "C:\Users\tezik\Desktop\Stata test stuff\GLOBAL.xlsx", sheet("Unicef data") firstrow

**Here I am making the data make sense to me. 
*I dropped columns 1 and 2  for the aesthetic and also because they were mostly empty
drop in 1/2
drop in 398/404
*Xlsx files can be challening to import and the accompanying CSV file was more than useless, so I needed to to change the variable names and label to clearly present the data.
rename Timeperiod country
label variable country "Country name"
rename D Y2022
rename E Y2021 
rename F Y2020 
rename G Y2019
rename H Y2018
** replacing all nonmumeric characters into numeric ones before i turn all the strings in the years(2018-2022) in to numeric values.
*stata turns the strings into doubles for some reason.
*the nonstring characters are now = 0. this may change as I continue cleaning and doing the analysis.
replace Y2022 = subinstr(Y2022, "-", ".", .)
replace Y2021 = subinstr(Y2021, "-", ".", .)
replace Y2020 = subinstr(Y2020, "-", ".", .)
replace Y2019 = subinstr(Y2019, "-", ".", .)
replace Y2018 = subinstr(Y2018, "-", ".", .)

destring Y2022 Y2021 Y2020 Y2019 Y2018, replace

****Since we are only looking at countries. I went ahead and dropped all noncountry/territory observations. 
*THERES DEFINATELY AN EASIER WAY TO DO THIS.
* chunk 1
drop if inlist(country, "(SDGRC) Central Africa", "(SDGRC) Eastern Africa", "(SDGRC) North Africa", ///
"(SDGRC) Southern Africa", "(SDGRC) United Nations Economic Commission for Africa", "(SDGRC) West Africa")

*chunk 2
drop if inlist(country, "Africa", "African Union", "Americas", "Arab Maghreb Union (AMU)", ///
"Arab States", "Asia and the Pacific", "Caribbean")

*chunk 3
drop if inlist(country, "Central Africa (African Union)", "Central America", "Central Asia", ///
"Central and Southern Asia", "Common Market for Eastern and Southern Africa (COMESA)", "Community of Sahel-Saharan States (CEN-SAD)")

*chunk 4
drop if inlist(country, "East African Community (EAC)", "East Asia and Pacific", "East and Southern Africa", ///
"Eastern Africa", "Eastern Africa (African Union)", "Eastern Asia", "Eastern Europe and Central Asia")

*chunk 5
drop if inlist(country, "Eastern Mediterranean", "Eastern and South-Eastern Asia", ///
"Economic Community of Central African States (ECCAS)", "Economic Community of West African States (ECOWAS 2025)", ///
"Economic Community of West African States (ECOWAS)", "Europe", "Europe and Central Asia")

*chunk 6
drop if inlist(country, "Intergovernmental Authority on Development (IGAD)", "Latin America and the Caribbean", ///
"Least Developed Countries (LDC)", "Middle Africa", "Middle East and North Africa", "North America", "North Africa")

*chunk 7
drop if inlist(country, "Northern Africa (African Union)", "Northern Africa and Western Asia", ///
"Northern America", "Oceania", "Oceania (exc. Australia and New Zealand)", "SDG regions - Global")

*chunk 8
drop if inlist(country, "South America", "South Asia", "South-East Asia", "South-eastern Asia", ///
"Southern Africa", "Southern Africa (African Union)", "Southern African Development Community (SADC)")

*chunk 9
drop if inlist(country, "Southern Asia", "State of Palestine", "Sub-Saharan Africa", "West Africa", ///
"World Bank (high income)", "World Bank (low income)", "World Bank (lower middle income)", "World Bank (upper middle income)")

*chunk 10
drop if inlist(country, "UNICEF Programme Regions - Global", "Eastern and Southern Africa", ///
"Northern Africa", "UNICEF reporting regions - Global", "West and Central Africa", "Western Africa")

*chunk 11
drop if inlist(country, "Western Africa (African Union)", "Western Asia", "Western Pacific", "Western Europe")

drop C

**Create dummy variable for antinatal care visits
encode B, generate(ACN4)
drop B
*Here we finally encode the countries to countryname
encode country, gen (countryname)

**since the there are multiple observations in the clean_countries variables with the same name, i will create an row_ID variable that correponds to the  
egen row_id = group(country)


************************************Experimental bit right here********************************************
**save the newly clean country data set right here as "clean_countries" in the stata .dta format before we load the tracker xlsx file.
save "C:\Users\tezik\Desktop\Stata test stuff\clean_countries.dta", replace

**load new tracker dataset 
import excel "C:\Users\tezik\Desktop\Stata test stuff\Track.xlsx", sheet("Sheet1") firstrow clear

**here we encode our tracker dataset to drop all the red (strings). this will allow us to work with it. 
encode StatusU5MR, gen(status)
encode OfficialName, gen(countryname)

*here I create a dummy variable for countries who have attained and those who have not attained.
gen achievment = "off-track"
replace achievment = "on-track" if inlist(StatusU5MR, "Achieved", "On-track")


drop ISO3Code OfficialName StatusU5MR
** Here I saved the tracker as a .dta file
save "C:\Users\tezik\Desktop\Stata test stuff\tracker.dta", replace

**Once the tracker is saved as a .dta file, we will open up the clean_countries .dta file.
use "C:\Users\tezik\Desktop\Stata test stuff\clean_countries.dta"

** Here will attempt an observations merge. this will merger the the "status" information in the tracker to each instance of the countey name in the clean_countries variabe 

*this bit of code will sort the clean_countries and create a new save file for where the countries will be sorted
use "tracker.dta", clear
sort countryname
save "tracker.dta", replace

*I perform the merge with the data from the tracker.dta to the clean_countries.dta. Now the observations from the tracker should be joined with the clean_countries. 
*Note that I am using 1:m because there are multiple observations of the same name in clean_countries which correspond to the ACN4 status. ANC4 variabe is going to be a dummy.

*There are also some obervation on the tracker that don't appear on the clean_countries. which is fine for now I suppose.
use "clean_countries.dta", clear
sort countryname
merge m:1 countryname using "tracker.dta"

**A bit more cleaning for good measure


**Dont change the order here
sort countryname
drop in 236/282

drop _merge 


**I reaized U used the wrong version of the UNICEF data, but at this point there is no going back. I have the version where the years are all seperated into individual variabes. No worries! I can recreate the correct version in stata by just creating  a variable that is the mean for all 4 years for each observation.

*Here I calculate the mean of each variable across all observations. Its close enough

egen MEAN = rowmean(Y2022 Y2021 Y2020 Y2019 Y2018)



***Now we will add the WPP 
* First, I will save the dataset in its current form.
save "C:\Users\tezik\Desktop\Stata test stuff\clean_countries.dta", replace
* Next I upload the Xlsx file. its quite large and the first 17 or so rows are unnessesary
import excel "C:\Users\tezik\Desktop\Stata test stuff\WPP2022.xlsx", sheet("Projections") cellrange(A17:BM22615) firstrow clear

*I am going to merge, so I changed the country list variabe to match the other dataset
rename Regionsubregioncountryorar countryname1




**here I destring the countr variabe in the populationdata.dta dataset.
encode countryname1, gen(countryname)



*Im dropping all other projection years except for 2022 because the readme said I must.
keep if Year == 2022

*using the CrudeBirthRatebirthsper10 variabe which, according tho the labe is the crude biths per 1000, I will create a new variable that shows the projected gross amaount

**drop the Holy See or else you will waste obsurd amounts of time researching destringing syntax
drop if inlist(countryname1, "Holy See")
destring CrudeBirthRatebirthsper10, replace

gen birth_projection = CrudeBirthRatebirthsper10 * 1000

***I am committed to only analyzing countries and not any other kind of category
drop if inlist(Type, "Development Group" , "Subregion", "Special other", "SDG region", "Region", "Income Group", "Development Group", "World")

sort countryname

rename countryname1 country


*I will now save the pupulationdata.dta so that i can merge it with the rest of my data
save "C:\Users\tezik\Desktop\Stata test stuff\populationdata.dta", replace

***Now I will load the unicef clean_countries.dta data set to begin the next merge

use "C:\Users\tezik\Desktop\Stata test stuff\clean_countries.dta", clear




*mergerd the populationdata.dta to the master dataset
use "clean_countries.dta", clear

sort country

merge m:1 country using "populationdata.dta"





** I dropped all of these variable because they will not be used for my final analysis
drop Index Variant Notes Locationcode ISO3Alphacode ISO2Alphacode SDMXcode Parentcode Year MedianAgeasof1Julyyears NaturalChangeBirthsminusDea RateofNaturalChangeper100 PopulationChangethousands PopulationGrowthRatepercenta PopulationAnnualDoublingTime Birthsthousands Birthsbywomenaged15to19t CrudeBirthRatebirthsper10 TotalFertilityRatelivebirth NetReproductionRatesurviving MeanAgeChildbearingyears SexRatioatBirthmalesper10 TotalDeathsthousands MaleDeathsthousands FemaleDeathsthousands CrudeDeathRatedeathsper10 LifeExpectancyatBirthboths MaleLifeExpectancyatBirthy FemaleLifeExpectancyatBirth LifeExpectancyatAge15both MaleLifeExpectancyatAge15 FemaleLifeExpectancyatAge15 LifeExpectancyatAge65both MaleLifeExpectancyatAge65 FemaleLifeExpectancyatAge65 LifeExpectancyatAge80both MaleLifeExpectancyatAge80 FemaleLifeExpectancyatAge80 InfantDeathsunderage1thou InfantMortalityRateinfantde LiveBirthsSurvivingtoAge1 UnderFiveDeathsunderage5 UnderFiveMortalitydeathsund MortalitybeforeAge40bothse MaleMortalitybeforeAge40de FemaleMortalitybeforeAge40 MortalitybeforeAge60bothse MaleMortalitybeforeAge60de FemaleMortalitybeforeAge60 MortalitybetweenAge15and50 MaleMortalitybetweenAge15an FemaleMortalitybetweenAge15 MortalitybetweenAge15and60 BJ BK NetNumberofMigrantsthousand NetMigrationRateper1000po TotalPopulationasof1Januar TotalPopulationasof1July MalePopulationasof1Julyt FemalePopulationasof1July PopulationDensityasof1July PopulationSexRatioasof1Ju
**drop these too
drop in 236/320
drop country Y2022 Y2021 Y2020 Y2019 Y2018 row_id _merge Type
*fixing some error
rename ACN4 ANC4

encode achievment, gen(track)
drop achievment
*****************

****************************************************************The Analysis******************************************************************************
**Here are the descriptive statistics




gen weighted_anc4 = (ANC4 / 1000 * birth_projection) if ANC4 ==1 
gen weighted_sba = (ANC4 / 1000 * birth_projection) if ANC4 ==2
*gen total_births = birth_projection, by(status)





*The stata gragh for this project
graph bar weighted_anc4 weighted_sba, over(track, label(angle(45)))legend(label(1 "ANC4") label(2 "SBA")) ytitle("Population-Weighted Coverage (%)") title("Health Service Coverage by U5MR Target Status", size(medium)) subtitle("2022")

*descriptive statistics that are useful for conclusions to be drawn.
su

inspect weighted_anc4 weighted_sba

list track weighted_anc4 weighted_sba, noobs clean




dyndoc coverage_report.stmd, replace export(pdf)























































