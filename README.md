# PlotPattern
MATLAB functions to plot 2D/3D radiation & scattering patterns, intended for antennas & metasurfaces.

## MATLAB functions

Two functions are included. Calling thems with no input arguments from the command window produces example plots.
1. **`plot_2D_Pattern_polar_dB.m`** -- Plots in polar-2D and in dB, with a few customizations on the vizualization.
2. **`plot_3D_Pattern.m`** -- Plots in 3D, in linear or dB. It includes a large number of customizations for the vizualization. For example, the 3D-surface plots can be in spherical (rho,phi,theta) or cylindrical (rho,phi,zeta) coordinate systems.

## MATLAB scripts & data

I am also including a script, **`script_read_LV_radpat.m`**, which reads-in and plots the 2D radiation patterns in E- and H-planes, as recorded by the Lab-Volt/Festo-Didactic "Antenna Training and Measuring System" software ([LVDAM-ANT](https://labvolt.festo.com/solutions/9_telecommunications/69-8092-00_antenna_training_and_measuring_system)) in ASCII-format; a sample half-wavelength antenna pattern is included for testing, in file: **`example_LVradpat_Export.txt`**.
