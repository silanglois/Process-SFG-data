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
    - [3 - Calibrate visible wavelength](#3---calibrate-visible-wavelength)
    - [4 - (Optional) Visualize raw data files](#4---optional-visualize-raw-data-files)
    - [5 - (Optional) Remove peaks due to cosmic-rays](#5---optional-remove-peaks-due-to-cosmic-rays)
    - [6 - Process and plot results](#6---process-and-plot-results)
    - [7 - Export processed data or create reports](#7---export-processed-data)
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
- Easy calibration of the visible wavelength using polystyrene

## Installation
1. Clone or download this repository.  
2. Open the `.mlapp` file in MATLAB (App Designer).  
3. Add the `supporting files` folder to your MATLAB path. Run `addpath(genpath("supporting files"));` 
in the command window, or right click onto the folder and select "add to path".  
4. Run the app from MATLAB App Designer.

## Usage
### 1 - Select input directory
In the "Data sorting" tab, select the directory (folder) in which you datafiles 
are located. You might be prompted to do it at start time, else simply use the 
"Set/change working directory" button on the top left.

> [!WARNING]
> At this time, only CSV files are supported. The columns must be labeled 
"Frame", "Wavelength" (in nanometers), and "Intensity" (see the example data).

![data sorting tab](/assets/data_sorting_tab.png)

### 2 - Match files
Use the dropdowns in the tables to match files in the data sorting tab.  
The files are pre-sorted into background files, reference files (e.g. quartz), 
calibration files (e.g. polystyrene), and sample files. If a file contains "bg", 
or "bkg", or "background" in its filename, it will be sorted as a background.  
If a file contains what is inputed in the `calibration string` or `reference string` 
fields, it will be sorted as calibration or reference, accordingly. All other 
files will be sorted as sample files.

Click the "Apply changes" button on the bottom right once done with the matching.

> [!TIP]
> If you name your files the same way I do, you might notice that 
most of this sorting is automatic. See [Example data](#example-data) for more details.

### 3 - Calibrate visible wavelength
Use the "Calibration" tab to calibrate the visible wavelength. In the dropdown on the top left, select which file you desire to use for calibration (the options are the different lines in the vis wavelength calibration tables in the data sorting tab). The raw data for the selected calibration file and the corresponding reference and background is plotted in the top left axis. Those datafiles are used to plot the measured absorbance of your calibration sample on the bottom left axis.[^calibration] The collected calibration absoption spectum is plotted against the imaginary refractive index of polystyrene, with the original data coming from the [National Institute of Standards and Technology](https://webbook.nist.gov/cgi/cbook.cgi?ID=C9003536&Mask=80#IR-Spec).

Change the number in the "Calibrate visible wavelength" field until the peak positions overlap between the NIST data and your collected data. You can use the sliders on the left to aid in getting the overlap more accurately: the baseline slider will shift the NIST spectrum up/down, and the multiplier slider will increase/decrease the NIST peaks amplitude.  

[^calibration]: At this time, only polystyrene is supported as it is the only calibration sample used by the Cyran Lab.

Here is an example of what is shown in the calibration tab, with the wavelength calibrated (overlap of the collected and NIST peaks):\
![calibration tab](/assets/calibration_tab.png)

### 4 - *(Optional)* Visualize raw data files
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

The cleaned data is shown by default, see [the following section](#5---optional-remove-peaks-due-to-cosmic-rays) for more details on data cleaning.

Here is an example of what is shown in the raw data tab:\
![raw data tab](/assets/raw_data_tab.png)

### 5 - *(Optional)* Remove peaks due to cosmic rays
*Still need to add docs*

![cosmic ray removal](/assets/cleaning.png)

### 6 - Process and plot results
In the sorting data tab, click the "Apply changes" button once you are satisfied 
with matching. Your data will be processed and displayed in the newly appeared 
"Processed data" tab.

![processed - not clean](/assets/processed-dirty.png)
![processed - clean](/assets/processed-clean.png)

### 7 - Export processed data
Once satisfied with your processed data, you can choose to export it by clicking the "Export" (or "Export selected") button at the bottom left of the processed data tab. You will be prompted to pick the directory (folder) in which you want the data files to be saved. A `.csv` file will be created for each produced SFG spectra. The first few rows contain information about the different files and settings used to obtain the processed data, which follows that information.

Here is an example of `.csv` file produced (only including the first few rows):
```
# Processed data export
# visible wavelength used : 794.55 nm
# Background file used: oa_50mgL_cold_ssp_6um_600s_0950_bg.csv
# Reference file used: zqz_cold_ssp_6um_10s_1051.csv
# Background for reference file: zqz_cold_ssp_6um_10s_1054_bg.csv
# Date processed: 2025-08-20 16:34
# -----------------------
Wavenumber,Intensity
2521.554484,66.375000
2520.067454,20.357143
2518.580759,26.564516
2517.094400,16.690909
2515.608376,24.445946
2514.122688,16.157895
2512.637336,19.760870
2511.152318,17.602041
2509.667636,21.450000
2508.183289,29.250000
```

## Example Data
You can find example `.csv` files in the example [`data`](/data/) folder.  
These files demonstrate the expected input format with columns labeled:  
- `Frame`
- `Wavelength` (in nanometers)
- `Intensity`

Also, those files are named using the specified naming system and therefore get sorted mostly automatically.

> [!TIP]
> This naming system is as follows: `SampleName(_numValue)(_condition1)(_condition2)_pol_region_acqtime_time(_bg).csv`, with
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

## Roadmap
Planned improvements:
- [ ] Extra background processing (offset, smoothing)
- [ ] Automate the visible wavelength calibration process
- [ ] Expand file format support beyond CSV

## License
This project is licensed under the MIT License.

## Troubleshooting
If these steps below do not solve your issues, please create a new 
[issue](https://github.com/silanglois/Process-SFG-data/issues).

1. Check that the supporting files folder is added to the path and accessible.
2. Check [existing issues](https://github.com/silanglois/Process-SFG-data/issues)
 for temporary fixes.

## Contributing
If you want to contribute, feel free to start a pull request.
See the current [roadmap](#roadmap) and the [current issues](https://github.com/silanglois/Process-SFG-data/issues) (it would be nice if those were gone), you may also start something new if you desire.
