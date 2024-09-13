clc
clear
%computational grid
% points_per_wavelength = 3;
% c0_min = 1500;
% f_max=50e6;
% x_size=.5;
dx = 50e-6%c0_min/(points_per_wavelength*f_max)
Nx = 256%round(x_size/dx)
Ny=Nx;
dy=dx;
kgrid = makeGrid(Nx,dx,Ny,dy);
%heterogenious medium
medium.sound_speed=1430*ones(Nx,Ny);
medium.sound_speed(:,1:Ny/2)=1647;
medium.density = 911*ones(Nx, Ny);
medium.density(:,(1:Nx/2)) = 1090;

% define the initial pressure
disc_x_pos=0;
disc_y_pos=0;
disc_radius=10;
disc_mag=3;
source.p0=disc_mag*makeDisc(Nx,Ny,disc_x_pos,disc_y_pos,disc_radius);
%define a linear sensor
sensor.mask = zeros(Nx, Ny);
sensor.mask(round(Nx/3),1:Ny) = 1;


%simulate
sensor_data = kspaceFirstOrder2D(kgrid, medium, source, sensor, 'PlotLayout', true,'RecordMovie',true,'MovieName','HeteroSim4Recon');
figure;
plot(sensor_data)
xlabel('Time Step');
ylabel('Sensor Amplitude');
title('Sensor Data');
figure(3);
imagesc(sensor_data, [-1, 1]);
colormap(getColorMap);
ylabel('Sensor Position');
xlabel('Time Step');
colorbar;
%time reversal reconstruction
source.p0=0;
sensor.time_reversal_boundary_data=sensor_data;
p0_recon=kspaceFirstOrder2D(kgrid, medium, source,sensor, 'RecordMovie',true, 'MovieName','HeteroRecon');