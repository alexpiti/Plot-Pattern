function plot_2D_Pattern_polar_dB(angdeg, rdB, rangedB, stepdB, stepdeg, noLeg)

% FUNCTION plot_2D_Pattern_polar_dB(phideg, rdB, rangedB, stepdB, stepdeg, noLeg)
%
% Makes 2D polar plot of angle-vs-r in logarithmic scale (for r). 
% It plots on the existing figure/axis, or creates a new one.
%
% Special settings are applied when plotting LVDAM-ANT patterns, 
% so that the figure plot matches the software GUI plot
%
% === Inputs ===
%  * phideg  = polar angles in [0,360] deg. Plots for [0,180] are mirrored.
%  * rdB     = radial distance in dB(log) scale, e.g., rdB=10*log10(r)
%  * rangedB = [min,max] dB range for the plot, default is [-30 +10]dB
%  * stepdB  = dB step for the plot markings, default is 10 dB
%  * stepdeg = deg step for the plot markings, default is 30 deg
%  * noLeg   = boolean, disables dB marks on the right, default is 0
%
% MIT License | Copyright (c) 2022 Alexandros Pitilakis, Thessaloniki/Greece

% Test inputs
if nargin == 0
    clc; close all; clear all;
    theta = linspace(eps,pi,100);
    kLs = 2*pi*[ 0.001 0.5 1 1.5 ];
    r = NaN*zeros(length(kLs),length(theta));
    for k = 1:length(kLs)
        kL = kLs(k);
        F = ( ( cos( kL/2*cos(theta) ) - cos(kL/2) )./ sin(theta) ).^2;
        r(k,:) = 2*F / trapz( theta, F.*sin(theta) );
    end
    rdB    = 10*log10( r );
    angdeg = theta*180/pi;   
       
end

% -------------------------------------------------------------------------
% Preliminary operations
% -------------------------------------------------------------------------

% Input argument check
if nargin == 1
    warning('myApp:argChk', 'Not enough input arguments.');
    help polar_dB; 
    return;
end

% Default inputs
if nargin < 6, noLeg = 0; end
if nargin < 5, stepdeg = 30; end
if nargin < 4, stepdB  = 10; end
if nargin < 3, rangedB = [-30 +10]; end; 

% Some more checks:
if length(angdeg) ~= length(rdB) % Multiple rad-pat plots:
    error( ' ## polar_dB:ERROR: rdB and phideg must be equal length!' )
end
if diff(rangedB) < 0 % error in range dB
    error( ' ## polar_dB:ERROR: rangedB should be [min_dB max_dB]!' ); 
end
if max(rdB(:)) > rangedB(2) % warning for dB-range
   disp( ' ## polar_dB:Warning: max rdB of curve(s) exceed(s) range!' ); 
end
if any( imag(rdB)~=0 ), % complex rdB
    error( ' ## polar_dB:ERROR: rdB complex? Real inputs only!');
end
   
% Number of "rays" for angle marking
rays = 360/stepdeg;

% Arrange phideg and rdB row-wise
angdeg = angdeg(:)';
if size(rdB,1) > size(rdB,2)
    rdB = rdB';
end

% LV rad-pats special settings
try
    LVspecial = min(size(rdB))==2 && all(angdeg==0:1:359);
catch
    LVspecial = 0;
end
if LVspecial
    rangedB = [-30 0];
    stepdB  = 5;
    rdB = rdB(:,[1:end,1]);
    angdeg = [angdeg,360];
end


% -------------------------------------------------------------------------
% Prepare polar plot area:
% -------------------------------------------------------------------------

% White circlular-board on which RadPat will be printed
if LVspecial==0
    figure;
end
phi0 = linspace(0,360,100);
R0   = 1; 
x0   = R0*sind(phi0); 
y0   = R0*cosd(phi0); 
patch('xdata',x0,'ydata',y0, 'edgecolor','black','facecolor','w'); 
hold on

% -------------------------------------------------------------------------
% Scale & Plot the Rad-Pat
% -------------------------------------------------------------------------  

% Colors for the curves, if multiple are to be plotted simultaneously
if LVspecial % E and H planes only
    colspace = [1 0 0; 0 0 1];
elseif size(rdB,1) <= 4
    colspace = [0 0 0; 1 0 0; 0 0.5 0;0 0 1]; 
else
    colspace = jet( size(rdB,1) );
end

% Crop rdB to min/max to fit in plot, and scale it to [0->1] for plot
rdBcr = rdB;
rdBcr( rdB >= rangedB(2) ) = rangedB(2); % crop to max
rdBcr( rdB <= rangedB(1) ) = rangedB(1); % crop to min
rdBsc = 1 + (rdBcr-rangedB(2)) / diff(rangedB); % scale to [0...1]

% Plot all the curves
for rp = 1 : min( size(rdB) )

    x = rdBsc(rp,:) .* cosd(angdeg);
    y = rdBsc(rp,:) .* sind(angdeg) * (-1)^LVspecial;
    hp(rp) = plot( y, x,'LineStyle','-','color',colspace(rp,:),'LineWidth', 2);
    
    % For Theta-plots (0...180 deg): mirror along vertical axis
    if max(angdeg) <= 180
        plot( -y, x,'LineStyle',':','color',colspace(rp,:),'LineWidth', 1)
    end

end

% Legend for the rdB plots
if LVspecial
    legend( hp , {'E','H'} );
elseif min( size(rdB) ) > 1
    legend( hp , num2str( (1 : min( size(rdB) ))' ) );
end

% -------------------------------------------------------------------------
% Plot "cosmetics": iso-dB cicles and phi-rays
% ------------------------------------------------------------------------- 

% Fixed radial (dB) distance circles
c_log = rangedB(1):stepdB:rangedB(2);
c = (c_log-rangedB(2))/diff(rangedB);  
for k = 2 : length(c_log)-1 % dont do the outmost (it's there) and inmost
    plot(x0*c(k), y0*c(k),'LineStyle',':','color','black');
end
 
% Markers/labels for the iso-radial (dB) distance circles
% place on the right side
if noLeg == false
    for k = 1 : length(c_log)
        
        dBval = c_log(length(c_log)-k+1);
        
        if k==1
            text(1.3,+c(k), sprintf( '\\bf{%+2.0f dB}' , rangedB(2) ),...
                'horizontalalignment', 'left', 'verticalalignment', 'middle'); %,'fontsize', 13
            text(1.3,-c(k), sprintf( '\\bf{%+2.0f dB}' , rangedB(2) ),...
                'horizontalalignment', 'left', 'verticalalignment', 'middle'); %,'fontsize', 13
        elseif k == length(c_log)
            text(1.3,+c(k), sprintf( '\\bf{%+2.0f dB}' , dBval ),...
                'horizontalalignment', 'left', 'verticalalignment', 'middle'); %,'fontsize', 13
        else
            text(1.3,+c(k), sprintf('%+2.0f dB',dBval),...
                'horizontalalignment', 'left', 'verticalalignment', 'middle'); %,'fontsize', 13
            text(1.3,-c(k), sprintf('%+2.0f dB',dBval),...
                'horizontalalignment', 'left', 'verticalalignment', 'middle'); %,'fontsize', 13
        end
        
    end
end

% Rays -- Indicating the angles
phi_s=linspace(0,2*pi,rays+1);
x_s = sin(phi_s);
y_s = cos(phi_s);

% Rays Labels -- For theta (0...180 deg), ray labels are mirrored
if max(angdeg) <= 180
    if mod(rays,2)~=0
        error( 'Only works for even number of "rays!"' );
    end        
    phi_s_label = phi_s( [1:(rays/2+1),(rays/2):-1:1] );  
else
    phi_s_label = phi_s; 
end
    

% Rays -- Plot 'em and label them
for k=1:rays
    % Lines
    line([x_s(k)/diff(rangedB)*stepdB,x_s(k)],...
       [y_s(k)/diff(rangedB)*stepdB,y_s(k)],'LineStyle',':','color','black');

    % Labels
    text(1.1*x_s(k)*(-1)^LVspecial,1.1*y_s(k),...
        sprintf('%.3g^o',phi_s_label(k)/pi*180),...
        'horizontalalignment', 'center', 'verticalalignment', 'middle'); %,'fontsize', 15
end

% Final touches
axis square;
axis off
