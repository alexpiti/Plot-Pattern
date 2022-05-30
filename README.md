# PlotPattern
MATLAB functions to plot 2D/3D radiation & scattering patterns, intended for antennas & metasurfaces.

## MATLAB functions

Two functions are included. Calling thems with no input arguments from the command window produces example plots.
1. **`plot_2D_Pattern_polar_dB.m`** -- Plots in polar-2D and in dB, with a few customizations on the vizualization.
2. **`plot_3D_Pattern.m`** -- Plots in 3D, in linear or dB. It includes a large number of customizations for the vizualization. For example, the 3D-surface plots can be in spherical (rho,phi,theta) or cylindrical (rho,phi,zeta) coordinate systems.

Here is how it looks:

![ExamplePattern_2D_dB](https://user-images.githubusercontent.com/97299585/170985799-0e989fea-c909-4635-84b5-d3668768bf33.png)

Fig. 1: E-plane patterns of center-fed dipole antennas of various lenghts: 1=Infinitesimal, 2=Half-wavelength, 3=Full-wave, 4=3/2 lambda. The patterns are by default symmetric as the dipole is arranged along the theta=0 axis (vertically, in this graph).

![ExamplePattern_3D_dB](https://user-images.githubusercontent.com/97299585/170985830-4e8e0332-a173-42a2-a88c-b6ec2c89b7a1.png)

Fig. 2: Directive 5-by-5 array pattern of isotropic radiators at half-wavelength distance along both lateral axes. Beam is pointed at (phi,theta)=(-120,30). The pattern in the left panel is in linear scale and spherical coordinates, while right panel holds the same pattern but in dB-scale and in cylindrical coordinates.

## MATLAB scripts & data

I am also including a script, **`script_read_LV_radpat.m`**, which reads-in and plots the 2D radiation patterns in E- and H-planes, as recorded in ASCII-format by the Lab-Volt/Festo-Didactic "Antenna Training and Measuring System" software ([LVDAM-ANT](https://labvolt.festo.com/solutions/9_telecommunications/69-8092-00_antenna_training_and_measuring_system)); a sample half-wavelength antenna pattern is included for testing, in file: **`example_LVradpat_Export.txt`**.

![ExamplePattern_Measured_Dipole](https://user-images.githubusercontent.com/97299585/170986612-234092d0-9035-436c-a30b-f5acccd26978.png)

Fig. 3: E- and H-plane patterns of a measured half-wavelength dipole antenna (at approximately 1 GHz).
