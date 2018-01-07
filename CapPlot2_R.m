function [] = CapPlot2_R(DATASET) %This function is used to plot a single dataset, including its average

loglog(DATASET.AvgData(:,1),DATASET.AvgData(:,4),'r','LineWidth',1) % Plotting the average data
hold on;
loglog(DATASET.AvgData(:,1),DATASET.AvgData(:,4)+3*DATASET.StdDev(:,4),'--','LineWidth',1,'Color',[.7 .7 .7]) % Plotting the average data
loglog(DATASET.AvgData(:,1),DATASET.AvgData(:,4)-3*DATASET.StdDev(:,4),'--','LineWidth',1,'Color',[.7 .7 .7]) % Plotting the average data
grid on;

legend('Mean','3 sigma'); % Writing the legend for Average trace

titlestr = strcat('Sensor ',DATASET.SensorID,'; T=',DATASET.Temperature,' °C'); % Putting together the plot title
if(DATASET.IsVacuum==1)
    titlestr=strcat(titlestr,'; vac.');
end
if(DATASET.IsPreBaked==1)
    titlestr=strcat(titlestr,'; pre-baked');
end

if(DATASET.VaporPresent==1)
    titlestr=strcat(titlestr,'; vapor');
end

if(DATASET.After==1)
    titlestr=strcat(titlestr,'; after');
end

title(titlestr); % Displaying the plot title
ylim([1 1e6]);
xlabel('f [Hz]');
ylabel('R [Ohm]');