# PGSCheck_ver5.0

## Version update (ver5.0):

- **Release date**: 2023/06/29
- **Updates**:
  - Added the first step to select the search method.
  - Changed the data storage and data calculation algorithm.
  - Added HighRisk output report graph (PR>98).
  - Added PR>98 keyword map (Wordcloud) function.
  - Using CMUH's 400,000-person genetic chip data.

## 1. Basic Instructions

This software calculates the PGS risk of each individual.

- **Software Requirements**:
  - R (ver4.1.1)
  - Batch shell operating environment

- **Minimum System Requirements**:
  - **OS**: Windows 7/8/10/11
  - **Processor**: Intel Core i5-4460 / AMD FX-8320
  - **RAM**: 8GB
  - **Hard disk space**: 10 GB
  - **Internet**: Broadband Internet connection
  - **Resolution**: 1024x768

## 2. Main Functions

1. **Step 1**: Select the search method (by name/by PatientID).
2. **Step 2**: Search the basic information of the individual in the TPMI database (optional).
3. **Step 3**: Calculate the PGS of the individual with the corresponding PatientID according to the user input and generate a PGS risk prediction plot.
4. **Step 4**: The result will be placed in: `./Result/[output file name]/` folder.

## 3. Attached Files

1. `TPMI_list_ver5.txt`: TPMI comparison table.
2. `TPMI_Family_40W.txt`: 40W gene kinship table.
3. `PGS_percentile_table_ver5.txt`: 40W sample PRS result table.
4. `PGS_codebook_ver5.txt`: PGS comparison Reported_Trait/Category comparison table.

## 4. Input Items

1. The method of inquiry (according to name/according to PatientID).
2. The name (full name) of the individual to be queried. (optional).
3. According to the query result of Step 2, enter the individual medical record number. (e.g., 12345600).
4. Select the Kinship Threshold for display (0.5/0.25/0.125).

## 5. How to Execute

Click the shortcut `PGSCheck_ver5.0` in the root directory to execute.
