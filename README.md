# The Importance of Monsoon Precipitation for Foundation Tree Species across the Semiarid Southwestern U.S.

## Model Code and Data Repository

#### Authors:

K.E. Samuels-Crow(1\*), D.M.P. Peltier(2,3), Y. Liu(4), J.S. Guo(5),
J.M. Welker(6,7,8), W.R. Anderegg(9), G.W. Koch(2,3), C.
Schwalm(3,10), M. Litvak(11), J.D. Shaw(12), K. Ogle(1,2,3)

### Affiliations:

1 School of Informatics, Computing, and Cyber Systems, Northern Arizona
University, Flagstaff, AZ, USA

2 Department of Biological Sciences, Northern Arizona University,
Flagstaff, AZ, USA

3 Center for Ecosystem Science and Society, Northern Arizona University,
Flagstaff, AZ, USA

4 Department of Geography and Environmental Sciences, Northumbria
University, Newcastle upon Tyne, UK

5 Arizona Experiment Station, University of Arizona, Tucson, AZ, USA

6 Department of Biological Sciences, University of Alaska, Anchorage,
AK, USA

7 Ecology and Genetics Research Unit, University of Oulu, Finland

8 University of the Arctic (UArctic), Rovaniemi, Finland

9 School of Biological Sciences, University of Utah, Salt Lake City, UT,
USA

10 Woodwell Climate Research Center, Falmouth, MA, USA

11 Department of Biology, University of New Mexico, Albuquerque, New
Mexico, USA

12 Rocky Mountain Research Station, USDA Forest Service, Logan, UT, USA

\*Corresponding Author
[Kimberly.Samuels\@nau.edu](mailto:Kimberly.Samuels@nau.edu)

This code and data repository includes model code and data files used in
the analysis presented in "The Importance of Monsoon Precipitation for
Foundation Tree Species across the Semiarid Southwestern U.S." submitted
to [Frontiers in Forests and Global
Change](https://www.frontiersin.org/journals/forests-and-global-change)
in December 2022.

`ModelCode/` contains a script for initializing and running the merged
stem and soil isotope mixing model along with the model code. This code,
script, and all data files should be stored in a single directory and
run in
[OpenBugs](https://www.mrc-bsu.cam.ac.uk/software/bugs/openbugs/).

-   `Model_SamuelsCrowetal_2023_IsotopeModel_Annotated.odc` contains the mixing model described in Samuels-Crow et al., 2023. Briefly, this model estimates the proportion of North American Monsoon precipitation contribution to soil moisture at various depths and then estimates the proportion of water from each of these soil depths to stem water extracted from 3 different tree species. See Samuels-Crow et al., 2023 for details.

-   `Script_SamuelsCrowetal_2023_IsotopeModel.odc` contains an OpenBUGS script to run the mixing model and monitor variables of interest. To run the model, first download the script, data files, and model to a single directory. Then, open the script file in the OpenBUGS GUI and set the working directory. Finally, go to the model menu and select "Script."

`DataFiles/` contains the five data files and initial values for each of three chains necessary to run the
model. The .odc files should be read into the OpenBugs model. The
.xlsx file summarizes data inputs that is stored in the five .odc files.

-   `Data_Dimension_bedrock.odc` includes dimension data for both stem and soil submodels

-   `data_inputs_Summary.xlsx` summarizes all data in a single,
    human-readable file. This file is not necessary to run the model, but it is included for ease of data access.

-   `Data_SiteSpeciesIndex.odc` There are 12 sites and 17 site-species combinations in the study described in Samuels-Crow et al., 2023. This file includes indices for the 3 soil depths for each site-species combination.

-   `Data_soilidentify_stemsubmodel_bedrock.odc` associates site-species with site and site type (aspen site = 1, PJ site = 2).

-   `Data_SoilInputs_bedrock.odc` contains soil water and end-member (monsoon or "bedrock") isotope data. The isotope data (pred_soil, postd_soil, and d_monsoon) are organized into 2 columns where column 1 is  &delta;<sup>2</sup>H and column 2 is  &delta;<sup>18</sup>O. For the bedrock end-member, a range of  &delta;<sup>18</sup>O values are provided (d18O_bed_low and d18O_bed_hi). See Samuels-Crow et al., 2023 for more information. This file also contains important identifying information to run the model.

-   `Data_StemInputs.odc` contains isotope data for stem water (d_pre_stem and d_post_stem) organized by tree.

-   `Inits_chain1.odc` contains the starting values for the first of
    three MCMC chains

-   `Inits_chain2.odc` contains the starting values for the second of
    three MCMC chains

-   `Inits_chain3.odc` contains the starting values for the third of
    three MCMC chains
    
#### Reference:

Samuels-Crow, K.E., Peltier, D.M.P., Liu, Y., Guo, J.S., Welker, J.M., Anderegg, W.R., Koch, G.K., Schwalm, C., Litvak, M., Shaw, J.D., Ogle, K. (2023). The Importance of Monsoon Precipitation for Foundation Tree Species across the Semiarid Southwestern U.S. *Frontiers in Forests and Global Change: Understanding Forest Ecosystems: The Use of Stable Isotopes and Physiological Measurements*, vol. 6. doi: 10.3389/ffgc.2023.1116786.
