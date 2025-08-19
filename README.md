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
    - [7 - Export processed data or create reports](#7---export-processed-data-or-create-reports)
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
fields, it will be sorted as calibration or reference, accordingly.[^1] All other 
files will be sorted as sample files.

Click the "Apply changes" button on the bottom right once done with the matching.

> [!TIP]
> If you name your files the same way I (Simon) do, you might notice that 
most of this sorting is automatic.

[^1]: An issue was raised on this topic.

### 3 - Calibrate visible wavelength
*Still need to add docs*

![calibration tab](/assets/calibration_tab.png)

### 4 - *(Optional)* Visualize raw data files
All checked files in the tree in the data sorting tab are plotted in the "Raw 
data" tab. Those can be visualized before mathcing the different files together.

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

### 7 - Export processed data or create reports
*Still need to add docs*


## Example Data
You can find example `.csv` files in the example [`data`](/data/) folder.  
These files demonstrate the expected input format with columns labeled:  
- `Frame`  
- `Wavelength` (in nanometers)  
- `Intensity`  

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
See the current [roadmap](#roadmap) and the 
[current issues](https://github.com/silanglois/Process-SFG-data/issues) (it would be nice if those were gone).
