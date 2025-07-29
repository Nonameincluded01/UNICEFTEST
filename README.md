## Project Goal

The primary goal of this script is to investigate whether countries that are "on-track" to meet under-5 mortality rate (U5MR) targets have a higher number of births covered by key maternal health interventions—specifically, at least four antenatal care visits (ANC4) and skilled birth attendants (SBA)—compared to countries that are "off-track".

## File Dependencies

To run this script successfully, you must have the following files located in the same directory as the `.do` file:

1.  **`GLOBAL.xlsx`**: The core UNICEF dataset containing indicators for various countries. (Originally named `fusion_GLOBAL_DATAFLOW_UNICEF_1.0_all.xlsx`).
2.  **`Track.xlsx`**: A tracker file that categorizes countries as "Achieved," "On-track," or "Off-track" in meeting U5MR goals.
3.  **`WPP2022.xlsx`**: The World Population Prospects 2022 data, used to get projected birth numbers for weighting the analysis.

## How to Run the Script

1.  **Set Up Your Folder:** Create a folder on your computer and place the `UNICEF Test.do` file inside it. Download and place the three required Excel files (`GLOBAL.xlsx`, `Track.xlsx`, and `WPP2022.xlsx`) into this same folder.

2.  **Edit the `.do` File:** Open `UNICEF Test.do` in Stata's Do-file Editor or any text editor. The very first line of code sets the working directory:
    ```stata
    cd "C:\Users\tezik\Desktop\Stata test stuff"
    ```
    You **must** change this file path to match the location of the folder you created in step 1. For example, if your folder is on your Desktop and named "UNICEF_Analysis", you would change it to:
    ```stata
    cd "C:\Users\YourUsername\Desktop\UNICEF_Analysis"
    ```

3.  **Execute in Stata:** Open Stata. You can run the script in one of two ways:
    * **Using the Menu:** Go to `File` -> `Do...`, navigate to your folder, and select `UNICEF Test.do`.
    * **From the Do-file Editor:** With the `UNICEF Test.do` file open in the editor, click the `Execute (do)` button on the toolbar.

4.  **Review the Output:** The script will run from top to bottom. The analysis outputs (tables and the bar chart) will be displayed in Stata's Results window. The script will also create several intermediate Stata datasets (`.dta` files) in your folder.


I ENCOURAGE YOU TO FOLLOW THESE INSTRUCTION, HOWEVER, IF YOU A FAMILIAR WITH STATA, THEN PLEASE SET UP YOUR ENVIRONMENT IN WHATEVER WAY MAKES YOU COMFORTABLE. THIS SCRIPT SHOULD RUN IN ANY ENVIRONMENT PROVIDED THAT YOU HAVE A COHERENT FILEPATH.

THHANK YOU
