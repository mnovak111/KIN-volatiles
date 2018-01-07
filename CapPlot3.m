function [] = CapPlot3(DATASET) %This function is used to plot a couple of datasets, its averages
% Use DatasetName struct to name each dataset
% Prepare various plot line styles
matlab_plotstyles = {'r-' 'g-' 'b-' 'c-' 'm-' 'y-' 'k-' 'r--' 'g--' 'b--' 'c--' 'm--' 'y--' 'k--' 'r:' 'g:' 'b:' 'c:' 'm:' 'y:' 'k:'};
dataset_num_incr = 1;

for dataset_num = 1:length(DATASET) % Go through all datasets
    if ~isempty(DATASET(dataset_num).SensorID) % If the sensor ID is empty, do not plot the data
        semilogx(DATASET(dataset_num).AvgData(:,1),DATASET(dataset_num).AvgData(:,5))
        hold on;
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
titlestr = 'Plot with multiple datasets - see legend';
grid on;
title(titlestr); % Displaying the plot title
legend(legendInfo); % Display the legend
xlabel('f [Hz]');
ylabel('C [F]');

% for dataset_num = 1:size(DATASET.CombinedData,3) % Going through all files in the dataset
%     semilogx(DATASET.CombinedData(:,1,dataset_num),DATASET.CombinedData(:,5,dataset_num),'k'); % Printing all files in a black color
% end