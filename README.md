# Process-SFG-data

A MATLAB App for processing Sum Frequency Generation (SFG) spectroscopy data. Originally built for the Cyran lab.

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
1. Load sample, background, and reference files.
2. Match files in the data sorting tab.
3. Process and plot results.
4. Export processed data or create reports.

## Requirements
- Fully programmed and tested using MATLAB R2025a. However, MATLAB R2023a or later *may* work (App Designer necessary).

## License
This project is licensed under the MIT License.

## Troubleshooting
If these steps below do not solve your issues, please raise the issue.

1. Check that the supporting files folder is added to the path and accessible.
2. 

## Contributing
If you want to contribute, feel free to start a pull request.

Features that would be nice to implement:
- Extra background processing; i.e. apply an offset, smoothing
- Automatize the vis wavelength calibration process.
- *feel free to suggest anything else*

Also see the current issues (it would be nice if those were gone).