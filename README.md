##########################################################################

                            PGSCheck_ver5.0

##########################################################################


Version update (ver5.0):

Release date: 2023/06/29

   1. Add the first step to select the search method.

   2. Change the data storage and data calculation algorithm.

   3. Added HighRisk output report graph (PR>98).

   4. Added PR>98 keyword map (Wordcolud) function.

   5. Using CMUH's 400,000-person genetic chip data.

############################ 1. Basic instructions #################################


- This software is to calculate the PGS risk of each individual.

- This software uses R (ver4.1.1) and Batch shell operating environment.

- Minimum system requirements:

     -OS: Windows/7/8/10/11

     -Processor: Intel Core i5-4460 / AMD FX-8320

     - RAM: 8GB

     - Hard disk space: 10 GB

     -Internet: Broadband Internet connection

     -Resolution: 1024*768
  
############################ 2. Main functions #################################


- Step 1: First select the search method (by name/by PatientID)

- Step 2: Search the basic information of the individual in the TPMI database (optional).

- Step 3: Calculate the PGS of the individual with the corresponding PatientID according to the user input and generate a PGS risk prediction plot.

- Step 4: The result will be placed in: ./Result/[output file name]/ folder.


############################ 3. Attach files #################################


- 1.TPMI_list_ver5.txt: TPMI comparison table.

- 2.TPMI_Family_40W.txt: 40W gene kinship table.

- 3.PGS_percentile_table_ver5.txt: 40W sample PRS result table.

- 4.PGS_codebook_ver5.txt: PGS comparison Reported_Trait/Category comparison table


############################ 4. Input items ###########################

- 1. The method of inquiry (according to name/according to medical record number).

- 2. The name (full name) of the individual to be queried. (optional)

- 3. According to the query result of Step2, enter the individual medical record number. Ex:12345600

- 4. Select the Kinship Threshold for display (0.5/0.25/0.125).

###########################  5. How to execute      ############################


- Click the shortcut: PGSCheck_ver5.0 in the root directory to execute.


##########################################################################
