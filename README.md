# wheresWhaledo
A tool to aide in recreating whale tracks via acoustic time difference of arrival (TDOA) localization from two 4-channel arrays.
Where's Whaledo is an add-on (remora) to Triton: http://cetus.ucsd.edu/technologies_Software.html
Required inputs: 
1) Long-term spectral averages (made by Triton from wav or x.wav files) for both arrays
2) Detection files for both arrays.

Detection files are .mat files containing the following structs (where N is the number of detections):
1) "TDet" (Dimensions Nx1): time of detection in MATLAB's datenum format.
2) "Ang" (Dim Nx2): angles of arrival to the array, where: Ang(:,1) represents the azimuthal angle in degrees, where 0 deg is due west, 90 deg is due north, etc; Ang(:,2) represents the elevation angle in degrees, where 0 deg is directly down, 180 deg is up.
3) "LDet" (Nx1): likelihood of detection, dimensions Nx1. An arbitrary value representing how likely a particular detection is an actual detection. Value could be average peak of the cross-correlation of the data across all four channels, peak energy, or other values user chooses.
4) "HydLoc" (1x3): Location of the array. HydLoc = [latitude, longitude, depth]. a) Latitude in decimal degrees is + for north, - for south of equator. b) Longitude is + for east, - for west of prime meridian. c) Depth is meters beneath sea surface (+ is down).

The program will autosave progress in "D:\tempsave.mat". \n
Maybe some day I'll make a user manual or comment my code, but today is not that day.
-ers, 2020-02-25
