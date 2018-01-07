function [] = CapPlot2(DATASET) %This function is used to plot a single dataset, including its average

semilogx(DATASET.AvgData(:,1),DATASET.AvgData(:,5),'r','LineWidth',1) % Plotting the average data
hold on;
semilogx(DATASET.AvgData(:,1),DATASET.AvgData(:,5)+3*DATASET.StdDev(:,5),'--','LineWidth',1,'Color',[.7 .7 .7]) % Plotting the average data
semilogx(DATASET.AvgData(:,1),DATASET.AvgData(:,5)-3*DATASET.StdDev(:,5),'--','LineWidth',1,'Color',[.7 .7 .7]) % Plotting the average data
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
xlabel('f [Hz]');
ylabel('C [F]');