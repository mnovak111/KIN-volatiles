function [] = CapPlot(AVG_PLOT, DATASET) % This function can parse through whole DATASET variable containing multiple datasets
% Prepare various plot line styles
matlab_plotstyles = {'r-' 'g-' 'b-' 'c-' 'm-' 'y-' 'k-' 'r--' 'g--' 'b--' 'c--' 'm--' 'y--' 'k--' 'r:' 'g:' 'b:' 'c:' 'm:' 'y:' 'k:'};
dataset_num_incr = 1;

for dataset_num = 1:length(DATASET) % Go through all datasets
    if ~isempty(DATASET(dataset_num).SensorID) % If the sensor ID is empty, do not plot the data
        if(AVG_PLOT) % If the average is enabled, plot it, otherwise plot the data separately
            semilogx(DATASET(dataset_num).AvgData(:,1),DATASET(dataset_num).AvgData(:,5))
            hold on;
        else
            
            for file_num = 1:length(DATASET(dataset_num).Data) % Go through all files within the dataset and plot it
                semilogx(DATASET(dataset_num).Data(file_num).data(:,1),DATASET(dataset_num).Data(file_num).data(:,5),matlab_plotstyles{dataset_num})
                hold on;
            end
        end
        legendstr = strcat('Sensor ',DATASET(dataset_num).SensorID,'; temp=',DATASET(dataset_num).Temperature,' °C'); % Prepare the legend text
        if(DATASET(dataset_num).IsVacuum==1)
            legendstr=strcat(legendstr,'; vacuum');
        end
        if(DATASET(dataset_num).IsPreBaked==1)
            legendstr=strcat(legendstr,'; pre-baked');
        end
        
        legendInfo{dataset_num_incr} = legendstr{1}; % Add the legend to the array of all legend texts
        
        dataset_num_incr = dataset_num_incr + 1; % Increment the dataset index number
    end
end
grid on;
legend(legendInfo); % Display the legend
xlabel('f [Hz]');
ylabel('C [F]');
end