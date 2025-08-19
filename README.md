# Process-SFG-data

A MATLAB App for processing Sum Frequency Generation (SFG) spectroscopy data. 
Originally built for the Cyran lab.

# Index

- [Process-SFG-data](#process-sfg-data)
  - [Features](#features)
  - [Installation](#installation)
  - [Usage](#usage)
    - [1 - Select input directory](#1---select-input-directory)
    - [2 - Match files](#2---match-files)
    - [3 - (Optional) Visualize raw data files](#3---optional-visualize-raw-data-files)
    - [4 - (Optional) Remove peaks due to cosmic-rays](#4---optional-remove-peaks-due-to-cosmic-rays)
    - [5 - Process and plot results](#5---process-and-plot-results)
    - [6 - Export processed data or create reports](#6---export-processed-data-or-create-reports)
  - [Requirements](#requirements)
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
4. Run the app from MATLAB.

## Usage
### 1 - Select input directory
In the "Data sorting" tab, select the directory (folder) in which you datafiles 
are located. You might be prompted to do it at start time, else simply use the 
"Set/change working directory" button on the top left.

Warning: at this time, only CSV files are supported. The columns must be labled 
"Frame", "Wavelength" (in nanometers), and "Intensity" (see the example data).

### 2 - Match files
Use the dropdowns in the tables to match files in the data sorting tab.\
The files are pre-sorted into background files, reference files (e.g. quartz), 
calibration files (e.g. polystyrene), and sample files. If a file contains "bg", 
or "bkg", or "background" in its filename, it will be sorted as a background. 
If a file contains what is inputed in the `calibration string` or `reference string` 
fields, it will be sorted as calibration or reference, accordingly.[^1] All other 
files will be sorted as sample files.

Note: If you name your files the same way I (Simon) do, you might notice that 
most of this sorting is automatic.

[^1]: An issue was raised on this topic.

### 3 - *(Optional)* Visualize raw data files
All checked files in the tree in the data sorting tab are plotted in teh "Raw 
data" tab.

### 4 - *(Optional)* Remove peaks due to cosmic rays
*Still need to add docs*

### 5. Process and plot results
In the sorting data tab, click the "Apply changes" button once you are done 
with the previous steps. Your data will be processed and displayed in the newly 
appeared "Processed data" tab.

### 6. Export processed data or create reports
*Still need to add docs*


## Requirements
- Fully programmed and tested using MATLAB R2025a. However, MATLAB R2023a or 
later *may* work (App Designer necessary).

## License
This project is licensed under the MIT License.

## Troubleshooting
If these steps below do not solve your issues, please create a new issue.

1. Check that the supporting files folder is added to the path and accessible.
2. Check existing issues for temporary fixes.

## Contributing
If you want to contribute, feel free to start a pull request.

Features that would be nice to implement:
- Extra background processing; i.e. apply an offset, smoothing
- Automatize the vis wavelength calibration process.
- *Feel free to suggest anything else: **simonlanglois@u.boisestate.edu***

Also see the current issues (it would be nice if those were gone).