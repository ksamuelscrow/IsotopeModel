# The Importance of Monsoon Precipitation for Foundation Tree Species across the Semiarid Southwestern U.S.

## Model Code and Data Repository

#### Authors:

K.E. Samuels-Crow(1\*), D.M.P. Peltier(2,3), Y. Liu(4), J.S. Guo(5),
J.M. Welker(6,7,8), W.R.L. Anderegg(9), G.W. Koch(2,3), C.
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

-   `Script_SamuelsCrowetal_2023_IsotopeModel.odc` contains a script to run the mixing model and monitor variables of interest.

`DataFiles/` contains data and initial values necessary to run the
model. The .odc files should be read into the OpenBugs model, while the
.xlsx file summarizes data inputs.

-   `Data_Dimension_bedrock.odc` associates X with Y

-   `data_inputs_Summary.xlsx` summarizes all data in a single,
    human-readable file

-   `Data_SiteSpeciesIndex.odc` associates X with Y

-   `Data_soilidentify_stemsubmodel_bedrock.odc` associates X with Y

-   `Data_SoilInputs_bedrock.odc` contains

-   `Data_StemInputs.odc` contains

-   `Inits_chain1.odc` contains the starting values for the first of
    three MCMC chains

-   `Inits_chain2.odc` contains the starting values for the second of
    three MCMC chains

-   `Inits_chain3.odc` contains the starting values for the third of
    three MCMC chains
