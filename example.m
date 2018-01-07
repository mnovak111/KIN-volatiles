%% Clear workspace
tic;

clc;
clear all;

%% Pre-initialize the struct
DATASET.FolderName    = [];
DATASET.SensorID    = [];
DATASET.IsVacuum    = [];
DATASET.IsPreBaked  = [];
DATASET.Temperature = [];
DATASET.After = [];
DATASET.Data = [];
DATASET.CombinedData = [];
DATASET.AvgData = [];
DATASET.StdDev = [];

%% Warning - data import may fail if improperly named folders and files (or other files not containing measurement data) are provided
%  Mandatory folder name structure:
%       HALD_vacuumDownT10 - example - D is the sensor name, word vacuum
%       specifies if the measurement was performed in vacuum, word Down
%       specifies if the sensor was preheated, 10 is the temperature
%  Mandatory file name structure is not given, however, the contents of the
%  file must strictly conform to the following structure (semicolon delimeter csv):
%       "f (Hz);Z (Ohm);Phi (deg);R (Ohm);C (F)"
%  No files in subfolder above the first folder will be parsed

%% List the directory, localize all files, sort them and import data samples
% Typical performance (2.3 GHz quadcore, SSD) - 4 folders, 40 files = 0.16 seconds

DATASET = Sensor_DataImport();

%%
%The DATASET variable contains a struct which contains imported data from
%all folders where the script is located. This struct has multiple layers,
%examples are provided below to understand the structure:
%
% DATASET - the whole struct
%
% DATASET(n) - access nth element of the struct, which contains Sensor ID,
% if the measurement was performed under vacuum, if the sensor was baked
% previously and the temperature. Within the Data
%
% DATASET(n).SensorID - access SensorID of the first folder
%
% DATASET(n).Data - the struct with all the data from different files
% within the nth folder
%
% DATASET(n).Data(m).name - access the name of mth file in nth folder
%
% DATASET(n).Data(m).data - access the contents of mth file in nth folder
% - dlmread function is used to parse the csv file

%% Plots

Fig_C = figure();
h(1) = subplot(2,2,1);
CapPlot2(DATASET(1));
h(2) = subplot(2,2,2);
CapPlot2(DATASET(2));
h(3) = subplot(2,2,3);
CapPlot2(DATASET(3));
h(4) = subplot(2,2,4);
CapPlot2(DATASET(4));

Fig_R = figure();
h(5) = subplot(2,2,1);
CapPlot2_R(DATASET(1));
h(6) = subplot(2,2,2);
CapPlot2_R(DATASET(2));
h(7) = subplot(2,2,3);
CapPlot2_R(DATASET(3));
h(8) = subplot(2,2,4);
CapPlot2_R(DATASET(4));



%% Plotting all the data in 2D cartesian plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameter AVG_PLOT determines whether to average all the results from the
% each dataset or plot all datasets separately

DATASET_T10 = CellSelect_Temperature(DATASET,10);
DATASET_T20 = CellSelect_Temperature(DATASET,20);
DATASET_T40 = CellSelect_Temperature(DATASET,40);
DATASET_T60 = CellSelect_Temperature(DATASET,60);

Fig3 = figure();
h(1) = subplot(2,2,1);
CapPlot3(DATASET_T10);
h(2) = subplot(2,2,2);
CapPlot3(DATASET_T20);
h(3) = subplot(2,2,3);
CapPlot3(DATASET_T40);
h(4) = subplot(2,2,4);
CapPlot3(DATASET_T60);


Fig4 = figure();
h(1) = subplot(2,2,1);
CapPlot3_R(DATASET_T10);
h(2) = subplot(2,2,2);
CapPlot3_R(DATASET_T20);
h(3) = subplot(2,2,3);
CapPlot3_R(DATASET_T40);
h(4) = subplot(2,2,4);
CapPlot3_R(DATASET_T60);

%% Model deriving and plotting

A = []; % Initializing an empty matrix

for dataset_num=1:size(DATASET,2) %concatenating the whole dataset
    A = [A;str2num(DATASET(dataset_num).Temperature{1})*ones(size(DATASET(1).AvgData,1),1) DATASET(dataset_num).AvgData(:,1) DATASET(dataset_num).AvgData(:,4) ];
end

% Plotting and cubic fitting of the data
MODEL__ = fit([A(:,1) A(:,2)],A(:,3),'cubicinterp', 'Exclude', A(:,2)<10); % Fitting the data to all measured values

X = 10:1:60; % Creating a mesh to display the model in the scatter plot
Y = logspace(1,6,100);
[p,q] = meshgrid(X, Y);
r = MODEL__(p,q);

f = figure();
scatter3(A(:,1),A(:,2),A(:,3),2,'b'); % Displaying the measured data
hold on;
scatter3(p(:), q(:),MODEL__(p(:),q(:)),1,'r'); % Displaying the model data

set(gca,'yscale','log'); % Setting logarithmic scale to the frequency axis
xlabel('T [°C]');
ylabel('f [Hz]');
zlabel('C [F]');
legend('Measured data','Model');
title('Comparison of the model to the measured data (dependence of C on T and f)')

% Model error
DATAPOINTS = [0 0 0 0 0]; % Initializing the matrix to determine model error
for dataset_num=1:size(DATASET,2) % For all datasets and files...
    for file_num = 1:size(DATASET(dataset_num).CombinedData,3)
        %Add the datapoints and leave the last column empty for model error calculation 
        datapoints_toadd = [ones(size(DATASET(1).AvgData,1),1)*str2double(DATASET(dataset_num).Temperature{1}) DATASET(dataset_num).CombinedData(:,1,file_num) DATASET(dataset_num).CombinedData(:,4,file_num) MODEL__(ones(size(DATASET(1).AvgData,1),1)*str2double(DATASET(dataset_num).Temperature{1}), DATASET(dataset_num).CombinedData(:,1,file_num)) zeros(size(DATASET(1).AvgData,1),1)];
        DATAPOINTS = [DATAPOINTS;datapoints_toadd];
    end
end
DATAPOINTS(1,:) = []; % Deleting the first line

DATAPOINTS(:,5) = (DATAPOINTS(:,4)-DATAPOINTS(:,3))./DATAPOINTS(:,3)*100; % Determine the error of the model
MainFigure4 = figure(); % Intialize a figure to show the results
histogram(DATAPOINTS(:,5),4000); % Plot the data as a histogram
xlim([-60 60]);
xlabel('Error of the model with respect to the measured data [%]');
ylabel('Magnitude of occurences');
title('Histogram showing the accuracy of the model');
grid on;

%% END OF THE SCRIPT
toc;
