% This scripts reads ASCII-exported data from Lab-Volt software (LVDAM-ANT)
% plots the polar-dB radiation patterns (E- and H-plane), and displays the
% metrics (Attenuation, Maximum Signal Level & Position, Half Power Beam
% Width) on the command window.
%
% === Notes ===
% * Plotting function "plot_2D_Pattern_polar_dB" is required.
% * ASCII data should be exported from LVANT-DAM software (File>Export)
%   You will be asked to provide the filename (full path will be required
%   if file is not in the same folder as this script).
% * Tested on MATLAB R2014a and Octave v5.1.1, both with LVDAM-ANT 2.3.
%
% MIT License | Copyright (c) 2022 Alexandros Pitilakis, Thessaloniki/Greece

% v1: Basic MATLAB (R2014a) functionality
% v2: Added corrections so that it works on Octave (5.1.1) too.
% v3: Minor corrections (Nov-2021)

clear all; close all; clc;

% Filename with ASCII-exported LV-ANT radiation pattern.
% You can replace the "input" command with the string of the filename, e.g.
%    filename = 'example_LVradpat_Export.txt';
% There's a sample export file (with the above name) in the repository.
filename = input( 'Give LVDAM-ANT ASCII filename (''string.txt''): ');

% Read the ASCII file. This is very simple with MATLAB (importdata
% function), but a bit more tricky with Octave (textscan function).
temp = ver;
isOctave = strcmp( temp(1).Name , 'Octave' );
if ~isOctave % MATLAB (IMPORTDATA)
    
    % Read the dB-attenuations used for E- and H-plane pattern measurements
    temp = importdata(filename, ' ', 13);
    att_EdB = temp.data(1);
    att_HdB = temp.data(2);
    
    % Read the two radiation patterns: [phideg, EdB, HdB]
    temp = importdata(filename, '\t', 17);
    phideg = temp.data(:,1)';
    EdB = temp.data(:,2)'; % attenuation is NOT corrected!
    HdB = temp.data(:,3)'; % attenuation is NOT corrected!
    
    % Read the metrics (MSL, MSP and HPBW) calculated from the software
    temp = importdata(filename, '\t', 379);
    E_metrics  = temp.data(:,1);
    H_metrics  = temp.data(:,2);
        
else % Octave (TEXTSCAN)
    
    disp( 'Octave (not MATLAB) detected. Hope it works...' )
    
    % Open the file for reading. MATLAB might "object" here, requiring you
    % to specify UTF=8 encoding specifically.
    fid = fopen( filename , 'r' ); 
    
    % Read the dB-attenuations used for E- and H-plane pattern measurements
    formatSpec = 'P - %*s - attenuation : %f';
    temp = textscan( fid , formatSpec, 2 , 'HeaderLines' , 13 );
    att_EdB = temp{1}(1);
    att_HdB = temp{1}(2);
    
    % Read the two radiation patterns: [phideg, EdB, HdB]
    formatSpec = '%f %f %f';
    temp = textscan( fid , formatSpec, 360 , 'HeaderLines' , 3 );
    phideg = temp{1};
    EdB    = temp{2}; % attenuation is NOT corrected!
    HdB    = temp{3}; % attenuation is NOT corrected!
    
    % Read the metrics (MSL, MSP and HPBW) calculated from the software
    % MATLAB and Octave use "HeaderLines" differently. If you use textscan
    % with MATLAB, replace 2 with 3 in the following line.
    temp1 = textscan( fid , 'MSL : %f %f', 1 ,'HeaderLines' , 2 ); 
    temp2 = textscan( fid , 'MSP : %f %f', 1 );
    temp3 = textscan( fid , 'HPBW: %f %f', 1 );
    E_metrics  = [temp1{1},temp2{1},temp3{1}];
    H_metrics  = [temp1{2},temp2{2},temp3{2}];    
    
    % Close the file.
    fclose(fid);  
    
end

% Do polar dB-plot for the E- and H-plane radiation patterns
figure('Position',[100 100 800 500],'NumberTitle','off','Name','LVDAM-ANT')
plot_2D_Pattern_polar_dB( phideg(:)', [EdB(:),HdB(:)]' );

% Print the metrics in a figure annotation and in the command window
strE = sprintf( 'E-plane:\n * Att  = %+2.0f dB\n * MSL  = %+4.2f dB\n * MSP  = %3.0f deg\n * HPBW = %5.2f deg\n',[att_EdB;E_metrics(:)]);
strH = sprintf( 'H-plane:\n * Att  = %+2.0f dB\n * MSL  = %+4.2f dB\n * MSP  = %3.0f deg\n * HPBW = %5.2f deg\n',[att_HdB;H_metrics(:)]);
fprintf( [strE,strH] )

% Annotation text-box (on figure) is also a bit different in syntax:
if ~isOctave % MATLAB (IMPORTDATA)
    annotation( 'textbox'  , 'string' , [strE,strH] ,...
        'BackgroundColor', 'w'  , 'Position',[ 0.01 0.01 0.2 0.4] );
else % Octave (TEXTSCAN)
    annotation( 'textbox' , [ 0.01 0.01 0.2 0.4] , ...
        'string' , [strE,strH] , 'BackgroundColor', 'w')
end
