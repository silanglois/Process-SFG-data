# Process-SFG-data

A MATLAB App for processing Sum Frequency Generation (SFG) spectroscopy data.
Originally built for the [Cyran lab](https://sites.google.com/view/cyranlab/home).

![License](https://img.shields.io/badge/license-MIT-green.svg)
![MATLAB](https://img.shields.io/badge/MATLAB-R2025a-blue.svg)
![App Designer](https://img.shields.io/badge/Made%20with-App%20Designer-orange.svg)

## Table of Contents

- [Process-SFG-data](#process-sfg-data)
  - [Features](#features)
  - [Installation](#installation)
  - [Usage](#usage)
    - [1 - Select input directory](#1---select-input-directory)
    - [2 - Match files](#2---match-files)
      - [Visualize raw data files](#visualize-raw-data-files)
    - [3 - Calibrate visible wavelength](#3---calibrate-visible-wavelength)
    - [4 - Process and plot results](#4---process-and-plot-results)
    - [5 - Export processed data or create reports](#5---export-processed-data)
  - [Additional features](#additional-features)
    - [Remove peaks induced by cosmic-rays](#remove-peaks-induced-by-cosmic-rays)
    - [Modify the background for a given signal](#modify-the-background-for-a-given-signal)
  - [Example Data](#example-data)
  - [Requirements](#requirements)
  - [Roadmap](#roadmap)
  - [License](#license)
  - [Troubleshooting](#troubleshooting)
  - [Contributing](#contributing)


## Features
- Automatically import data
- Files matching (signal/background, sample/reference)
- Full processing (frames averaging, background subtraction, normalization, ...)
- Offers to possibility to clean cosmic rays from the data
- Offers the possibility to slightly modify the background used for a given signal
- Easy calibration of the visible wavelength using polystyrene

## Installation
1. Clone or download this repository.  
2. Open the `.mlapp` file in MATLAB (App Designer).  
3. Add the `supporting files` folder to your MATLAB path. Run `addpath(genpath("supporting files"))` in the command window, or right click onto the folder and select "add to path".  
4. Run the app from MATLAB App Designer.

## Usage
### 1 - Select input directory
In the "Data sorting" tab, select the directory (folder) in which you datafiles 
are located. You might be prompted to do it at start time, else simply use the 
"Set/change working directory" button on the top left.

> [!WARNING]
> At this time, only CSV files are supported. The columns must be labeled 
"Frame", "Wavelength" (in nanometers), and "Intensity" (see the example data).

<img width="1430" height="842" alt="data_sorting_tab" src="https://github.com/user-attachments/assets/6e6dbf75-a9cb-4d0b-9544-de28ff7e67b3" />

### 2 - Match files
Use the dropdowns in the tables to match files in the data sorting tab.  
The files are pre-sorted into background files, reference files (e.g. quartz), 
calibration files (e.g. polystyrene), and sample files. If a file contains "bg", 
or "bkg", or "background" in its filename, it will be sorted as a background.  
If a file contains what is inputed in the `calibration string` or `reference string` 
fields, it will be sorted as calibration or reference, accordingly. All other 
files will be sorted as sample files. To help you match files together, or to make sure you are using the right files, you can [visualize the raw spectra](#visualize-raw-data-files) of those files. 

Click the "Apply changes" button on the bottom right once done with the matching.

> [!TIP]
> If you name your files the same way I do, you might notice that most of this sorting is automatic. See [Example data](#example-data) for more details.

#### Visualize raw data files
All checked files in the tree in the data sorting tab are plotted in the "Raw 
data" tab. Those can be visualized before matching the different files together.

In the raw data tab, you can use the checkbox tree on the left to view the data corresponding to specific files (the nodes can be expanded or collapsed as needed). You will notice that this tree is organized as follows:
> - Raw data
>   - Samples
>   - References
>   - Backgrounds
> - Cleaned data
>   - Samples
>   - References
>   - Backgrounds

The cleaned data is shown by default, see [the corresponding section](#remove-peaks-induced-by-cosmic-rays) for more details on data cleaning.

Here is an example of what is shown in the raw data tab:\
<img width="1428" height="820" alt="raw_data_tab" src="https://github.com/user-attachments/assets/bf051867-3ee9-4833-8817-7e34745e0345" />

### 3 - Calibrate visible wavelength
Use the "Calibration" tab to calibrate the visible wavelength. In the dropdown on the top left, select which file you desire to use for calibration (the options are the different lines in the vis wavelength calibration tables in the data sorting tab). The raw data for the selected calibration file and the corresponding reference and background is plotted in the top left axis. Those datafiles are used to plot the measured absorbance of your calibration sample on the bottom left axis.[^calibration] The collected calibration absoption spectum is plotted against the imaginary refractive index of polystyrene, with the original data coming from the [National Institute of Standards and Technology](https://webbook.nist.gov/cgi/cbook.cgi?ID=C9003536&Mask=80#IR-Spec).

Change the number in the "Calibrate visible wavelength" field until the peak positions overlap between the NIST data and your collected data. You can use the sliders on the left to aid in getting the overlap more accurately: the baseline slider will shift the NIST spectrum up/down, and the multiplier slider will increase/decrease the NIST peaks amplitude.  

[^calibration]: At this time, only polystyrene is supported as it is the only calibration sample used by the Cyran Lab.

Here is an example of what is shown in the calibration tab, with the wavelength calibrated (overlap of the collected and NIST peaks):\
<img width="1427" height="840" alt="calibration_tab" src="https://github.com/user-attachments/assets/c33771e5-1982-4085-a7e9-ca3000aa9a14" />

### 4 - Process and plot results
In the sorting data tab, click the "Apply changes" button once you are satisfied 
with matching. Your data will be processed and displayed in the newly appeared 
"Processed data" tab.

Here are examples of some processed SFG spectra. Cosmic rays were still not fully cleaned in the first screenshot, but fully cleaned in the second.
<img width="1433" height="839" alt="processed-dirty" src="https://github.com/user-attachments/assets/4de45521-bcf5-4656-9efa-76b77f80ff6c" />
<img width="1426" height="823" alt="processed-clean" src="https://github.com/user-attachments/assets/72e56d7e-4c1f-47f4-92bf-6cfd50083a10" />


### 5 - Export processed data
Once satisfied with your processed data, you can choose to export it by clicking the "Export" (or "Export selected") button at the bottom left of the processed data tab. You will be prompted to pick the directory (folder) in which you want the data files to be saved. A `.csv` file will be created for each produced SFG spectra. The first few rows contain information about the different files and settings used to obtain the processed data, which follows that information.

Here is an example of `.csv` file produced (only including the first few rows):
```
# Processed data export
# visible wavelength used : 793.1 nm
# Background file used: cell_ssp_6um_30s_1007_bg.csv; the background intensity was modified as: Intensity * 0.7 + 180; and the smoothing factor used was 0.05
# Reference file used: zqz_ssp_6um_10s_0941.csv
# Background for reference file: zqz_ssp_6um_10s_0942_bg.csv; the background intensity was modified as: Intensity * 1 + 0; and the smoothing factor used was 0
# Date processed: 2025-08-27 14:19
# -----------------------
Wavenumber,Intensity
2498.544367,0.640678
2497.057337,1.342500
2495.570642,3.808696
2494.084283,2.087500
2492.598260,0.615000
2491.112572,0.629268
```

## Additional features

### Remove peaks induced by cosmic rays
Cosmic rays can induce sharp intense peaks on the spectra. If unfortunate, those peaks can end up obsucring spectral features. However, due to the intense and sharp nature of those peaks, they are relatively easy to clean algorithmically. The `filloutliers(int, "linear", "movmedian", obj.window, ThresholdFactor=obj.tf)` function is used; the window and threshold factor parameters have default values, but can be ajusted manually by the user by using the "Additional cleaning" tab pictured below.

<img width="1427" height="833" alt="cleaning_table" src="https://github.com/user-attachments/assets/37f8fb1e-f9ad-4bb4-9868-1d5273157412" />

Select the lines in the table that correspond to the files you want to adjust the parameters of then press the edit button at the top right. A new window (pictured below) should appear, you can adjust the cleaning parameters and see the results of those modifications in the plotting area. The red circles show points that have been labeled as outliers and therefore removed, the spectra plotted is the "clean" spectra. Press save once you are satisfied with the cleaning. 

<img width="1221" height="654" alt="cleaning_app" src="https://github.com/user-attachments/assets/6c53f903-e892-4e91-9948-9eeccb0885f8" />

> [!NOTE]
> Multiple files can be cleaned at once (by selecting multiple rows). However, they will all have the same parameters; for different cleaning paratemers you will have to iterate the cleaning steps for each group of files.

> [!NOTE]
> The peaks are removed before any processing steps (averaging, normalizing, etc...) as this is when they are the sharpest and therefore the easiest to remove algorithmically.

> [!IMPORTANT]
> If you have already matched files together (see [Match files](#2---match-files)), press "Apply changes" once you are done with setting the cleaning parameters for your files.

### Modify the background for a given signal
*Still need to add docs*

<img width="1428" height="837" alt="bg_modif" src="https://github.com/user-attachments/assets/367b2a14-b132-4bc0-81b5-add0bb9f911f" />
<img width="1202" height="733" alt="bg_app" src="https://github.com/user-attachments/assets/7fdc59a6-891f-4b67-8fd3-e32749d8b2f6" />


## Example Data
You can find example `.csv` files in the example [`data`](/data/) folder.  
These files demonstrate the expected input format with columns labeled:  
- `Frame`
- `Wavelength` (in nanometers)
- `Intensity`

Also, those files are named using the specified naming system and therefore get sorted mostly automatically.

> [!TIP]
> **The naming system is as follows:**\
>  `SampleName(_numValue)(_condition1)(_condition2)_pol_region_acqtime_time(_bg).csv`, with
> - `SampleName`: Name of the sample. Can be any combination of letters/symbols/numbers (with exceptions, see below).
> - `numValue`: *optional* a numbered value followed by a combination of letters (e.g. "5mgL").
> - `condition1`: *optional* Any combination of letters/symbols/numbers (with exceptions, see below).
> - `condition2`: *optional* Any combination of letters/symbols/numbers (with exceptions, see below).
> - `pol`: Sequence of three letters in any combination of the letters s and p (e.g. "ssp").
> - `region`: A number followed by "um" (e.g. "5.5um"). This number represents the central wavelength of your IR light.   
> - `acqtime`: A number followed by "s", intended to be the length of your spectrum acquisition in seconds (e.g. "300s") 
> - `time`: The time a which the spectrum acquisition was started, in 24hr time, without units or seconds (e.g. "1540" for a spectrum taken at 3:40 PM)
> - `bg`: *optional* Used to indicate that a file is a background file.
> 
> Each of those is separated by one underscore. You can use capital letters, but those are not differenciated when reading the filenames. You may include dots and spaces (although it is not necessarily good practice), but you may NOT include slashes, or underscores other than the ones separating the different tokens.
>
> **For Cyran Lab members:** If you use the experiment tracker I built, the filename given should follow this pattern. I recommend using it as it makes your life much easier.

## Requirements
- MATLAB R2025a (R2024b does not work)

The app should work on both windows and macos, although it has only been tested on windows so far.

## Roadmap
Planned improvements:
- [ ] *Nothing for now, feel free to suggest features you would like implemented.*

## License
This project is licensed under the MIT License.

## Troubleshooting
If the steps below do not solve your problems, please create a new 
[issue](https://github.com/silanglois/Process-SFG-data/issues).

1. Check that the supporting files folder is added to the path and accessible.
2. Check [existing issues](https://github.com/silanglois/Process-SFG-data/issues) for temporary fixes.
3. Contact Simon.

## Contributing
If you want to contribute, feel free to start a pull request.
See the current [roadmap](#roadmap) and the [current issues](https://github.com/silanglois/Process-SFG-data/issues) (it would be nice if those were gone), you may also start something new if you desire.
